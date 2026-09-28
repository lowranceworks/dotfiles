---
name: tmux-ops
description: Inspect and drive the user's tmux sessions and workmux coding agents via the bash tool
---

# tmux & workmux operations

Cy shares the user's tmux server (same user, same socket). Use the `bash`
tool with these patterns.

## Read-first inspection (default)

- Sessions: `tmux ls`
- Windows across all sessions: `tmux list-windows -a -F '#{session_name}:#{window_index} #{window_name}'`
- Panes in a window: `tmux list-panes -t SESSION:WINDOW -F '#{pane_index} #{pane_current_command} #{pane_current_path}'`
- Read what's on screen: `tmux capture-pane -t SESSION:WINDOW.PANE -p`
- Scrollback too: `tmux capture-pane -t SESSION:WINDOW.PANE -p -S -200`

When summarizing what a session is doing, capture the pane and report the
last meaningful lines — never dump full capture output back to the user.

## workmux agents

The user runs coding agents in worktrees via workmux:

- `workmux list` — active worktrees/agents
- `workmux status` — agent status per worktree
- `workmux capture <name>` — recent output from an agent
- `workmux send <name> "instruction"` — send a prompt to a running agent
- `workmux dashboard` is a TUI — don't run it; use the non-interactive commands

## Sending input (only when asked)

- `tmux send-keys -t SESSION:WINDOW.PANE "command" Enter`

Never send keys, kill sessions, or interrupt running processes unless the
user explicitly asked. Prefer reporting what you see and proposing the
action.
