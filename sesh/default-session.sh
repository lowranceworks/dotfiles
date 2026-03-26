#!/bin/bash
# Rename default window
tmux rename-window -t 1 nvim

# Create additional windows with names
tmux new-window -n fish
tmux new-window -n fish

# Send commands to each window
tmux send-keys -t 1 'nvim .' Enter

# Focus on editor window
tmux select-window -t nvim
