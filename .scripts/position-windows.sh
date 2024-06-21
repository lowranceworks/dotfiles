#!/usr/bin/env sh

# Wait a moment to ensure windows are loaded
sleep 1

# Get window IDs
wezterm=$(yabai -m query --windows | jq -r '.[] | select(.app == "WezTerm") | .id')
inkdrop=$(yabai -m query --windows | jq -r '.[] | select(.app == "Inkdrop") | .id')

# Move WezTerm to space 2
if [ -n "$wezterm" ]; then
	yabai -m window $wezterm --space 2
	sleep 0.5 # Give time for the window to move to the space
fi

# Move Inkdrop to space 2
if [ -n "$inkdrop" ]; then
	yabai -m window $inkdrop --space 2
	sleep 0.5 # Give time for the window to move to the space
fi

# Focus on space 2 to ensure the commands apply to the correct space
# yabai -m space --focus 2
# sleep 0.5

# Adjust layout within space 2
if [ -n "$wezterm" ] && [ -n "$inkdrop" ]; then
	# Ensure Inkdrop is on the left
	yabai -m window $inkdrop --focus
	sleep 0.5

	# Resize Inkdrop to be smaller
	yabai -m window $inkdrop --resize right:-880:0
	sleep 0.5

	# Ensure WezTerm is on the right
	yabai -m window $wezterm --focus
	sleep 0.5

	# # Resize WezTerm to be larger
	# yabai -m window $wezterm --resize left:1380:0
	# sleep 0.5
fi
