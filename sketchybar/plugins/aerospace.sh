#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Error: No workspace provided" >&2
  echo "Usage: $0 <workspace_name>" >&2
  exit 1
fi

WORKSPACE=$1
CURRENT_WORKSPACE=$(/opt/homebrew/bin/aerospace list-workspaces --focused | tr -d '[:space:]')

echo "Debug:" >&2
echo "WORKSPACE: $WORKSPACE" >&2
echo "CURRENT_WORKSPACE: $CURRENT_WORKSPACE" >&2

if [[ "$WORKSPACE" == "$CURRENT_WORKSPACE" ]]; then
  echo "Match found - highlighting $WORKSPACE" >&2
  sketchybar --set space."$WORKSPACE" \
    background.drawing=on \
    background.color=0x44ffffff \
    icon.highlight=on \
    label.drawing=on
else
  echo "No match - dimming $WORKSPACE" >&2
  sketchybar --set space."$WORKSPACE" \
    background.drawing=off \
    icon.highlight=off
fi
