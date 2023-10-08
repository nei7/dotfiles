#!/bin/bash


## Get data


## Get status
get_status() {
	STATUS="$(playerctl status)"
	if [[ $STATUS == "Playing" ]]; then
		echo "(label :halign 'center' :hexpand false :text '󰏤')"
	else
		echo "(label :halign 'center' :hexpand false :text '󰐊')"
	fi
}

## Get song
get_song() {
	song=`playerctl metadata --format "{{ artist }} - {{ title }}"`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}


get_title(){
	song=`playerctl metadata --format "{{ title }}"`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}

get_artist(){
	song=`playerctl metadata --format "{{ artist }}"`
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

get_cover() {
	TMP_DIR="$HOME/.cache/eww"
	TMP_COVER_PATH=$TMP_DIR/cover.png
	TMP_TEMP_PATH=$TMP_DIR/temp.png

	if [[ ! -d $TMP_DIR ]]; then
		mkdir -p $TMP_DIR
	fi


	ART_FROM_SPOTIFY="$(playerctl -p %any,spotify metadata mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g')"
    ART_FROM_BROWSER="$(playerctl -p %any,mpd,firefox,chromium,brave metadata mpris:artUrl | sed -e 's/file:\/\///g')"
	if [[ $(playerctl -p spotify,%any,firefox,chromium,brave,mpd metadata mpris:artUrl) ]]; then
	curl -s "$ART_FROM_SPOTIFY" --output $TMP_TEMP_PATH
	elif [[ -n $ART_FROM_BROWSER ]]; then
		cp $ART_FROM_BROWSER $TMP_TEMP_PATH
	else
		cp $HOME/.config/eww/assets/music-fallback.png $TMP_TEMP_PATH
	fi

	cp $TMP_TEMP_PATH $TMP_COVER_PATH
	echo $TMP_COVER_PATH
}

## Execute accordingly
if [[ "$1" == "--song" ]]; then
	get_song
elif [[ "$1" == "--artist" ]]; then
	get_artist
elif [[ "$1" == "--title" ]]; then
	get_title
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
elif [[ "$1" == "--muted" ]]; then 
  { echo $(amixer get Capture | tail -n 1 | grep -c '\[on\]'); }
elif [[ "$1" == "--cover" ]]; then
 	get_cover
fi