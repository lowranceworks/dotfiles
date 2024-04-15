#!/bin/bash
tmux split-window -h -l 66%
tmux select-pane -t 0
tmux split-window -v
tmux send-keys -t 1 'lazygit' Enter
tmux send-keys -t 0 'clear' Enter
tmux send-keys -t 2 'nvim .' Enter
tmux select-pane -t 2
