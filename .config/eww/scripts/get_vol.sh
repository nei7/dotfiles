#!/bin/sh
if [ $1 == "speaker" ]
then
    amixer sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1
elif [ $1 == "mic" ]
then
    amixer sget Capture | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1
fi