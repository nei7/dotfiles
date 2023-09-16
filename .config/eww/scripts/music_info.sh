#!/bin/bash


## Get data
STATUS="$(playerctl status)"

## Get status
get_status() {
	
	if [[ $STATUS == "Playing" ]]; then
		echo "(box :halign 'center' :hexpand false :class 'pause')"
	else
		echo "(box :halign 'center' :hexpand false :class 'play')"
	fi
}

## Get song
get_song() {
	song=`playerctl metadata --format "{{ artist }}{{ album }} - {{ title }}"`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}


## Get time
get_time() {
	time=`playerctl metadata --format "{{ duration(mpris:length) }}"`
	if [[ -z "$time" ]]; then
		echo "0"
	else
		echo "$time"
	fi	
}

## Execute accordingly
if [[ "$1" == "--song" ]]; then
	get_song
elif [[ "$1" == "--status" ]]; then
	get_status
elif [[ "$1" == "--time" ]]; then
	get_time
elif [[ "$1" == "--toggle" ]]; then
	playerctl play-pause
elif [[ "$1" == "--next" ]]; then
	{ playerctl next; }
elif [[ "$1" == "--prev" ]]; then
	{ playerctl next; }
fi