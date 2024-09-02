#!/usr/bin/env bun

import dbus, { type ClientInterface } from 'dbus-next'
import type { Position, Song } from './types';
import { updateEww } from './utils';
import crypto from 'crypto'
import axios from 'axios'
import path from 'path'

const MPRIS_DIR = '/home/nei/.cache/eww';
const players = new Map<string, Song>()
const postitions = new Map<string, Position>()

async function getArtwork(artworkUrl: string) {
    if (!artworkUrl) return ""
    if (artworkUrl.startsWith("file://")) {
        return artworkUrl.replace("file://", "");
    }

    const fileName = crypto.createHash('sha1').update(artworkUrl).digest('hex');
    let savePath = path.join(MPRIS_DIR, fileName);
    let file = Bun.file(savePath)
    if (!await file.exists()) {
        if (artworkUrl.startsWith("https://")) {
            const response = await axios.get(artworkUrl, { responseType: 'arraybuffer' });
            await Bun.write(file, response.data)
        }
    }

    return savePath;
};


function formatTime(seconds: number) {
    if (seconds < 3600) {
        const minutes = Math.floor(seconds / 60);
        let remainingSeconds = seconds % 60;
        remainingSeconds = Math.round(remainingSeconds)
        return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    } else {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        let remainingSeconds = seconds % 60;
        remainingSeconds = Math.round(remainingSeconds)
        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    }
}

async function getProperty<T = any>(propInterface: ClientInterface, property: string): Promise<T> {
    const { value }: dbus.Variant = await propInterface.Get("org.mpris.MediaPlayer2.Player", property)
    return value
}

function getPlayerName(name: string): string {
    return name.split(".instance")[0].replace("org.mpris.MediaPlayer2.", "")
}

async function updateSong(name: string, p: ClientInterface) {
    try {
        const metadata = await getProperty(p, "Metadata")
        const playbackStatus = await getProperty(p, "PlaybackStatus")
        const canGoNext = await getProperty(p, "CanGoNext")
        const canGoPrevious = await getProperty(p, "CanGoPrevious")
        const canPlay = await getProperty(p, "CanPlay")
        const canPause = await getProperty(p, "CanPause")
        const artwork = await getArtwork(metadata['mpris:artUrl']?.value)

        const playerName = getPlayerName(name)

        const length = Number(metadata['mpris:length']?.value) / 1000000 || 0

        players.set(name, {
            serviceName: name,
            name: playerName,
            title: metadata['xesam:title']?.value,
            status: playbackStatus,
            artist: metadata['xesam:artist']?.value.join(", "),
            album: metadata['xesam:album']?.value,
            length,
            lengthStr: formatTime(length),
            artwork,
            canGoNext,
            canGoPrevious,
            canPlay,
            canPause,
        })

        await updateEww("players", JSON.stringify(Array.from(players.values())))
    } catch (err) {
        console.error(err)
    }
}

async function updatePostion(name: string, p: ClientInterface) {
    try {
        const position = Number(await getProperty<BigInt>(p, "Position")) / 1000000

        postitions.set(name, {
            position,
            positionStr: formatTime(position)
        })

        await updateEww("positions", JSON.stringify(Object.fromEntries(postitions)))
    } catch (err) {
        console.error(err)
    }
}


async function watchPlayer(name: string) {
    try {
        const playerObject = await bus.getProxyObject(name, '/org/mpris/MediaPlayer2');
        const propInterface = playerObject.getInterface('org.freedesktop.DBus.Properties');

        setInterval(() => updatePostion(name, propInterface), 1000)


        updateSong(name, propInterface)

        propInterface.on('PropertiesChanged', () => updateSong(name, propInterface));
    } catch (err) {
        console.error(err)
    }
};



const bus = dbus.sessionBus();
if (!bus) {
    console.error('Failed to connect to the D-Bus session bus.');
    process.exit(1);
}


const dbusObject = await bus.getProxyObject('org.freedesktop.DBus', '/org/freedesktop/DBus');
const dbusInterface = dbusObject.getInterface('org.freedesktop.DBus');

const activePlayers = new Map<string, string>()

const services: string[] = await dbusInterface.ListNames()

for (const name of services) {
    const owner = await dbusInterface.GetNameOwner(name)
    if (name.startsWith("org.mpris.MediaPlayer2")) {
        activePlayers.set(owner, name)
        watchPlayer(name)
    }
}



dbusInterface.on('NameOwnerChanged', async (name: string, oldOwner: string, newOwner: string) => {
    if (!name.startsWith("org.mpris.MediaPlayer2")) {
        return
    }

    if (newOwner !== "" && !activePlayers.has(newOwner)) {
        activePlayers.set(newOwner, name)
        watchPlayer(name)
    }

    if (activePlayers.has(oldOwner)) {
        activePlayers.delete(oldOwner)
        players.delete(name)
        await updateEww("players", JSON.stringify(Array.from(players.values())))

    }
});



process.stdin.resume();
