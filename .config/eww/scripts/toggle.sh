#!/bin/bash

STATE=$(eww get $1)
if [[ $STATE == false ]]; then
    eww update $1=true
else
    eww update $1=false
fi
