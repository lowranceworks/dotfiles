#!/bin/bash

PCT=$(top -l 1 -n 0 | awk '/CPU usage/ {printf "%.0f", $3 + $5}')

if [ "$PCT" -lt 50 ]; then
  COLOR=0xffa6e3a1 # green
elif [ "$PCT" -lt 85 ]; then
  COLOR=0xfff9e2af # yellow
else
  COLOR=0xfff38ba8 # red
fi

sketchybar --set "$NAME" label="${PCT}%" label.color="$COLOR" icon.color="$COLOR"
