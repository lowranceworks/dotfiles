#!/usr/bin/env sh

sketchybar \
  --add item \
  cpu_usage right \
  --set \
  cpu_usage icon=󰻠 \
  icon.font="$FONT:Bold:16.0" \
  icon.padding_left=5 \
  icon.padding_right=5 \
  label.font="$FONT:Semibold:11.0" \
  label.padding_left=5 \
  label.padding_right=5 \
  background.color=$TRANSPARENT \
  background.height=26 \
  background.corner_radius=11 \
  update_freq=5 \
  script="$PLUGIN_DIR/cpu.sh"
