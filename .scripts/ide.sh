#!/bin/bash
tmux split-window -h -l 66%
tmux select-pane -t 0
tmux send-keys -t 0 'clear' Enter
tmux send-keys -t 1 'nvim .' Enter
tmux select-pane -t 1
