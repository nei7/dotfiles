#!/bin/bash

function handle {
    case $1 in
    'activewindow>>'* | 'closewindow>>'* | 'openwindow>>'*)
        get_workspaces
        get_current_window
        ;;
    'movewindow>>'* | 'changefloatingmode>>'* | 'fullscreen>>'*)
        get_workspaces
        ;;
    'workspace>>'*)
        get_current_workspace
        ;;
    esac
}

function get_workspaces {
    eww update workspaces="$(hyprctl workspaces -j | jq -r 'sort_by(.id)')"
}

function get_current_workspace {
    eww update current_workspace="$(hyprctl activeworkspace -j)"
}

function get_current_window {
    window=$(hyprctl activewindow -j)
    class=$(echo $window | jq -r '.class')
    icon=$(grep -i "Icon" /usr/share/applications/$class.desktop | sed 's/Icon=//')
    icon_path=$(find /usr/share/icons/ /usr/share/pixmaps/ -name "$icon.*" -print -quit)
    
    echo $(echo $window | jq ". += {\"icon_path\": \"$icon_path\"}" -r  --unbuffered)
 
} 

get_current_workspace
get_workspaces
get_current_window

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
