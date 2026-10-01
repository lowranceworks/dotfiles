#!/bin/bash
tmux \
  rename-window -t 1 nvim \; \
  send-keys 'nvim .' Enter
