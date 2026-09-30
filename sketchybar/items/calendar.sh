#!/usr/bin/env sh

sketchybar \
  --add item \
  calendar right \
  --set \
  calendar icon.drawing=off \
  label.color=0xff74c7ec \
  label.font="$FONT:Bold:13.0" \
  label.padding_left=5 \
  label.padding_right=5 \
  background.drawing=off \
  update_freq=30 \
  script="$PLUGIN_DIR/calendar.sh"
