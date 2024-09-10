#!/bin/bash

INTERFACE=enp4s0
while true; do
    R1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    sleep 1
    R2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

    RBPS=$(expr $R2 - $R1)
    RKBPS=$(expr $RBPS / 1024)

    echo "$RKBPS kB/s"
done
