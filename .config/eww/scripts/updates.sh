#!/bin/bash
TMPPATH="${TMPDIR:-/tmp}/checkup-db-${USER}"
DBPATH="$(pacman-conf DBPath)"

mkdir -p "$TMPPATH"
ln -s "$DBPATH/local" "$TMPPATH" &>/dev/null
fakeroot -- pacman -Sy --dbpath "$TMPPATH" --logfile /dev/null &>/dev/null
pacman -Qu --dbpath "$TMPPATH" 2>/dev/null | wc -l