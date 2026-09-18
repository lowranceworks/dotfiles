#!/usr/bin/env sh

sketchybar \
  --add item \
  swap right \
  --set \
  swap icon=󰾴 \
  icon.font="$FONT:Bold:16.0" \
  icon.padding_left=5 \
  icon.padding_right=5 \
  label.font="$FONT:Semibold:11.0" \
  label.padding_left=5 \
  label.padding_right=5 \
  background.color=$TRANSPARENT \
  background.height=26 \
  background.corner_radius=11 \
  update_freq=10 \
  script="$PLUGIN_DIR/swap.sh"
