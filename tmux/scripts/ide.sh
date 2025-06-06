#!/bin/bash

# Get session name from command line or use default
SESSION_NAME=${1:-"new-session"}

# Check if we're already in a tmux session
if [ -n "$TMUX" ]; then
  # If already in tmux, create new windows in current session
  tmux new-window -n "nvim"
  tmux new-window -n "terminal"

  # Attach to the session
  tmux attach-session -t "$SESSION_NAME"
fi
