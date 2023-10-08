#!/bin/bash
WEATHER=$(curl --max-time 5 -sS 'https://api.open-meteo.com/v1/forecast/?latitude=50.02&longitude=22.67&current_weather=true')

CODE=$(echo $WEATHER | jq -r '.current_weather.weathercode')
case $CODE in
    3)
      printf "☁️ "
      ;;

    20)
      printf "🌨️ "
    ;;
    *)
    printf "☀️ "
    ;;
esac

echo $WEATHER | jq -r '.current_weather.temperature'  | awk '{print int($1+0.5)}'
