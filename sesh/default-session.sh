#!/bin/bash
tmux \
  rename-window -t 1 nvim \; \
  send-keys 'nvim .' Enter \; \
  new-window -n fish \; \
  new-window -n fish \; \
  select-window -t nvim
