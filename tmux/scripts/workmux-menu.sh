#!/bin/bash

# workmux menu, bound to prefix + w (see tmux.workmux.conf)

tmux display-menu -T "#[align=centre] workmux " -x C -y C \
  "dashboard"            d "display-popup -E -w 90% -h 90% 'workmux dashboard'" \
  "toggle sidebar"       s "run-shell 'workmux sidebar'" \
  "list worktrees"       l "display-popup -E -w 70% -h 50% 'workmux list; read'" \
  "" \
  "add worktree"         a "command-prompt -p 'add worktree (branch):' 'run-shell \"workmux add %1\"'" \
  "add (window mode)"    w "command-prompt -p 'add window (branch):' 'run-shell \"workmux add --mode window %1\"'" \
  "open worktree"        o "command-prompt -p 'open worktree (name):' 'run-shell \"workmux open %1\"'" \
  "merge worktree"       m "command-prompt -p 'merge worktree (name):' 'run-shell \"workmux merge %1\"'" \
  "remove worktree"      r "command-prompt -p 'remove worktree (name):' 'run-shell \"workmux remove %1\"'"
