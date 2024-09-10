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

generate_json_array() {
    local x=$1
    local json="["
    for ((i = 1; i <= x; i++)); do
        json+="{\"id\": $i}"
        if [ $i -lt $x ]; then
            json+=", "
        fi
    done
    json+="]"
    echo $json
}

function get_workspaces {
    workspaces=$(hyprctl workspaces -j | jq -r -c 'sort_by(.id)')

    json_array=$(generate_json_array $(echo $workspaces | jq -r '.[-1].id'))

    eww update workspaces="$(echo -e "$workspaces\n$json_array" | jq -s 'add' | jq 'unique_by(.id) | sort_by(.id)' -r)"
}

function get_current_workspace {
    eww update current_workspace="$(hyprctl activeworkspace -j)"
}

function get_current_window {

    window=$(hyprctl activewindow -j)
    class=$(echo $window | jq -r '.class' | awk '{print tolower($0)}')
    icon=$(grep -i "Icon" /usr/share/applications/$class*.desktop 2>/dev/null | sed 's/Icon=//')
    if [ -z $icon ]; then
        echo $window
        return
    fi

    icon_path=$(find /usr/share/icons/ /usr/share/pixmaps/ -name "$icon.*" -print -quit)
    if [ -z $icon_path ]; then
        echo $window
        return
    fi

    echo $(echo $window | jq ". += {\"icon_path\": \"$icon_path\"}" -r --unbuffered)
}

get_current_workspace
get_workspaces
get_current_window

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
