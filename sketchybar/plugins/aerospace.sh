#!/usr/bin/env bash

WORKSPACE=$1
CURRENT_WORKSPACE=$(aerospace workspace current)

if [[ "$WORKSPACE" == "$CURRENT_WORKSPACE" ]]; then
  sketchybar --set space."$WORKSPACE" \
    background.drawing=on \
    icon.highlight=on
else
  sketchybar --set space."$WORKSPACE" \
    background.drawing=off \
    icon.highlight=off
fi
