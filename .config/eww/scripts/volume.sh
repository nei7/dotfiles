#!/bin/bash

SINK=$(pactl list short sinks | grep RUNNING | awk '{print $1}')
SOURCE=$(pactl list short sources | grep RUNNING | awk '{print $1}')

display_volume() {
  output_volume=$(pactl list sinks | grep -A 15 "Sink #$SINK" | grep 'Volume:' | head -n 1 | awk '{print $5}' | tr -d '%')
  output_muted=$(pactl list sinks | grep -A 15 "Sink #$SINK" | grep 'Mute:' | awk '{print $2}')
  if [ "$output_muted" == "yes" ]; then
    output_muted="true"
  else
    output_muted="false"
  fi

  input_volume=$(pactl list sources | grep -A 15 "Source #$SOURCE" | grep 'Volume:' | head -n 1 | awk '{print $5}' | tr -d '%')
  input_muted=$(pactl list sources | grep -A 15 "Source #$SOURCE" | grep 'Mute:' | awk '{print $2}')
  if [ "$input_muted" == "yes" ]; then
    input_muted="true"
  else
    input_muted="false"
  fi

  echo '{"output":{"volume": '$output_volume', "muted": '$output_muted' }, "input":{"volume": '$input_volume', "muted": '$input_muted'}}'
}

display_volume

pactl subscribe | while read -r event; do
  if echo "$event" | grep -q -E -i "(sink|source)"; then
    display_volume
  fi
done
