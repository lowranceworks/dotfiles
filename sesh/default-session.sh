#!/bin/bash
# Rename default window
tmux rename-window -t 1 nvim

# Create additional windows with names
tmux new-window -n opencode
tmux new-window -n lazygit
tmux new-window -n fish

# Send commands to each window
tmux send-keys -t 1 'nvim .' Enter
tmux send-keys -t lazygit 'lazygit' Enter
tmux send-keys -t fish 'eza --group-directories-last --tree' Enter

# Focus on editor window
tmux select-window -t fish
