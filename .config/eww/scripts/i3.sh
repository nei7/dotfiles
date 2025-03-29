#!/bin/bash

function handle {
    case $1 in
    'activewindow>>'* | 'closewindow>>'* | 'openwindow>>'* )
        get_workspaces
        get_current_window
        ;;
    'movewindow>>'* | 'changefloatingmode>>'* | 'fullscreen>>'* )
        get_workspaces
        ;;
    'workspace>>'* )
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
    workspaces=$(i3-msg -t get_workspaces | jq -c 'sort_by(.num)')

    last_id=$(echo "$workspaces" | jq 'map(.num)')
    json_array=$(generate_json_array $last_id)


    eww update workspaces="$(echo -e "$workspaces\n$json_array" | jq -s 'add' | jq 'unique_by(.num) | sort_by(.num)' -r)"
}

function get_current_workspace {
    current=$(i3-msg -t get_workspaces | jq -c '.[] | select(.focused == true)')
    eww update current_workspace="$current"
}

function get_current_window {
    window_id=$(xdotool getactivewindow)

    class=$(xprop -id "$window_id" WM_CLASS | awk -F '"' '{print tolower($4)}')
    name=$(xprop -id "$window_id" WM_NAME | cut -d '"' -f 2)

    icon=$(grep -i "Icon" /usr/share/applications/$class*.desktop 2>/dev/null | sed 's/Icon=//')
    if [ -z "$icon" ]; then
        echo "{\"title\": \"$name\", \"class\": \"$class\"}"
        return
    fi

    icon_path=$(find /usr/share/icons/ /usr/share/pixmaps/ -wholename "*/$icon.*" -print -quit)
    if [ -z "$icon_path" ]; then
        echo "{\"title\": \"$name\", \"class\": \"$class\"}"
        return
    fi

    echo "{\"title\": \"$name\", \"class\": \"$class\", \"icon_path\": \"$icon_path\"}"
}

get_current_workspace
get_workspaces
get_current_window

i3-msg -t subscribe -m '[ "window", "workspace" ]' | while read -r line; do
    if [ -z "$line" ]; then
        continue
    fi


    event=$(echo "$line" | jq -r '.change')
    if [ -z "$event" ]; then
        continue
    fi

    case "$event" in
        "focus" | "title" | "new" | "close")
            get_workspaces
            get_current_window
            get_current_workspace
            ;;
        "move")
            get_workspaces
            ;;
        "init" | "empty" | "urgent")
            # workspace change events
            get_current_workspace
            get_workspaces
            ;;
    esac
done
