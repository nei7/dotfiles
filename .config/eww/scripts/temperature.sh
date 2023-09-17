#!/bin/bash
curl -sS 'https://api.open-meteo.com/v1/forecast/?latitude=50.02&longitude=22.67&current_weather=true' | jq -r '.current_weather.temperature'