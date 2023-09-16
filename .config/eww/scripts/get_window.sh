#!/bin/bash

WM_DESKTOP=$(xdotool getwindowfocus)

if [ $WM_DESKTOP == "Enter WM_DESKTOP value here" ]; then
	echo "Desktop"
elif [ $WM_DESKTOP != "1883" ]; then
	WM_CLASS=$(xprop -id $(xdotool getactivewindow) WM_CLASS | awk 'NF {print $NF}' | sed 's/"/ /g')
	WM_NAME=$(xprop -id $(xdotool getactivewindow) WM_NAME | cut -d '=' -f 2 | awk -F\" '{ print $2 }')

    if [ $WM_NAME == "" ]; then
        echo "Desktop"
    else
        echo $WM_NAME
    fi
fi
