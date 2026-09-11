#!/bin/bash

eval $(sysctl -n vm.swapusage | awk '{
  gsub(/M/, "", $0)
  for (i=1; i<=NF; i++) {
    if ($i == "total") printf "TOTAL=%d\n", $(i+2)+0
    if ($i == "used") printf "USED=%d\n", $(i+2)+0
  }
}')

if [ "$TOTAL" -eq 0 ] || [ -z "$TOTAL" ]; then
  sketchybar --set "$NAME" label="0%" label.color=0xffa6e3a1 icon.color=0xffa6e3a1
  exit 0
fi

PCT=$((USED * 100 / TOTAL))

if [ "$PCT" -lt 25 ]; then
  COLOR=0xffa6e3a1 # green
elif [ "$PCT" -lt 75 ]; then
  COLOR=0xfff9e2af # yellow
else
  COLOR=0xfff38ba8 # red
fi

sketchybar --set "$NAME" label="${PCT}%" label.color="$COLOR" icon.color="$COLOR"
