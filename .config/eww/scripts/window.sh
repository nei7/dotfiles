#!/bin/bash

function handle {
    case $1 in 'activewindow>>'* | 'closewindow>>'* | 'openwindow>>'*)
        hyprctl activewindow -j | jq --unbuffered -r ".title"
        ;;
    esac
}

hyprctl activewindow -j | jq --unbuffered -r ".title"
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
