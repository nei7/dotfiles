#!/bin/sh

picom -b --experimental-backend
dunst &
nitrogen --restore
exec i3