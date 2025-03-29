#!/bin/bash

if [[ "$XDG_CURRENT_DESKTOP" == *"i3"* ]]; then
    /home/nei/.config/eww/scripts/i3.sh
elif [[ "$XDG_CURRENT_DESKTOP" == *"Hyprland"* ]]; then
    /home/nei/.config/eww/scripts/hyprland.sh
fi