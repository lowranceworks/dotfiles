#!/bin/bash
tmux \
  rename-window -t 1 nvim \; \
  send-keys 'nvim .' Enter \; \
  new-window -n workmux \; \
  send-keys 'workmux dashboard --tab worktrees' Enter
