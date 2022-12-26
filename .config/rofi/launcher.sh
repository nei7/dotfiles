#!/usr/bin/env bash

theme="main.rasi"
dir="$HOME/.config/rofi"

themes=($(ls -p --hide="launcher.sh" --hide="colors.rasi" $dir))
rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
