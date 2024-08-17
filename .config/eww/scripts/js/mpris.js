#!/usr/bin/env node

const dbus = require('dbus-next');
const { exec } = require('child_process');
const util = require('util');
const crypto = require('crypto');
const axios = require('axios');
const path = require("path")
const fs = require("node:fs")

const MPRIS_DIR = '/home/nei/.cache/eww';

const getArtwork = async (artwork) => {
  if (!artwork) return ""
  if (artwork.startsWith("file://")) {
    return artwork.replace("file://", "");
  }

  const fileName = crypto.createHash('sha1').update(artwork).digest('hex');
  let savePath = path.join(MPRIS_DIR, fileName);

  if (!artwork || artwork.length > 200) {
    savePath = path.join(MPRIS_DIR, player);
  }

  if (!fs.existsSync(savePath)) {
    if (artwork.startsWith("https://")) {
      const response = await axios.get(artwork, { responseType: 'arraybuffer' });
      fs.writeFileSync(savePath, response.data)
    }
  }

  return savePath;
};


function formatTime(seconds) {
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


async function main() {
  const bus = dbus.sessionBus();
  if (!bus) {
    console.error('Failed to connect to the D-Bus session bus.');
    process.exit(1);
  }
  const dbusObject = await bus.getProxyObject('org.freedesktop.DBus', '/org/freedesktop/DBus');
  const dbusInterface = dbusObject.getInterface('org.freedesktop.DBus');

  async function getPlayers() {
    const services = await dbusInterface.ListNames()

    return services.filter(service => service.startsWith('org.mpris.MediaPlayer2.'));
  }

  let players = await getPlayers()

  dbusInterface.on('NameOwnerChanged', async (name, oldOwner, newOwner) => {
    const new_players = await getPlayers()


    for (const serviceName of new_players.filter(_ => !players.find(p => p === _))) {
      monitorPlayer(serviceName)
    }
    players = new_players
  });

  players.forEach(serviceName => monitorPlayer(serviceName))

  let playersObj = {}
  let postitions = {}

  async function monitorPlayer(serviceName) {
    try {

      const playerObject = await bus.getProxyObject(serviceName, '/org/mpris/MediaPlayer2');
      const propertiesInterface = playerObject.getInterface('org.freedesktop.DBus.Properties');

      setInterval(async () => {
        try {
          const position = Number((await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "Position")).value) / 1000000
          postitions[serviceName] = {
            position,
            positionStr: formatTime(position)
          }
          exec(`eww update position='${JSON.stringify(postitions)}'`)


        } catch (e) {
          // console.error(e)
        }

      }, 1000)

      const updateSong = async () => {
        try {
          const metadata = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "Metadata")).value
          const playbackStatus = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus")).value
          const canGoNext = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "CanGoNext")).value
          const canGoPrevious = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "CanGoPrevious")).value
          const canPlay = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "CanPlay")).value
          const canPause = (await propertiesInterface.Get("org.mpris.MediaPlayer2.Player", "CanPause")).value

          const name = serviceName.split(".instance")[0].replace("org.mpris.MediaPlayer2.", "")

          const length = Number(metadata['mpris:length']?.value) / 1000000 || 0

          playersObj[serviceName] = {
            serviceName,
            name,
            title: metadata['xesam:title']?.value,
            status: playbackStatus,
            artist: metadata['xesam:artist']?.value.join(", "),
            album: metadata['xesam:album']?.value,
            length,
            lengthStr: formatTime(length),
            artwork: await getArtwork(metadata['mpris:artUrl']?.value).catch(err => console.error(err)),
            canGoNext,
            canGoPrevious,
            canPlay,
            canPause,
          }

          console.log(
            JSON.stringify(Object.values(playersObj))
          )


        } catch (err) {
          if (err instanceof dbus.DBusError) {
            return
          }

          console.log(err)

        }


      };

      propertiesInterface.on('PropertiesChanged', updateSong);

      updateSong()
    } catch (err) {
      console.log(err)
    }


  };

}


main()













// Keep the script running
process.stdin.resume();
