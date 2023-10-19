#!/usr/bin/env bash

theme="main.rasi"
dir="$HOME/.config/rofi/launcher"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
