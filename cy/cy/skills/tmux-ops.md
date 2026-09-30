---
name: tmux-ops
description: Inspect and drive the user's tmux sessions and orchestrate workmux coding agents via the bash tool
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

## workmux: orchestrating coding agents

workmux creates a git worktree + tmux session per task, each hosting a
coding agent. Cy acts as the manager: the user texts a task, Cy spins up an
agent, monitors it, reports back, and cleans up.

### Lifecycle

1. **Create** — from the TARGET repo directory (ask the user which repo if
   unclear): `cd /path/to/repo && workmux add <task-name>`
   This makes a worktree at `<repo>__worktrees/<task-name>` plus a tmux
   session with editor/server/agent windows.
2. **Start an agent** in its agent window, e.g.:
   `workmux send <task-name> --window agent 'pi --model bonsai/bonsai2-27b'`
   (pi uses the local model; `opencode` uses Copilot Enterprise — prefer
   opencode for bigger tasks)
3. **Task it** — `workmux send <task-name> "your instruction here"`, or run
   one-shot commands with `workmux run <task-name> -- "cmd"` (the `--` is required).
4. **Monitor** — `workmux list`, `workmux status`, `workmux capture <name>`.
   `workmux wait <name>` blocks until the agent signals done.
5. **Report** — summarize for the user: what the agent did, diff stats
   (`git -C <worktree> diff --stat`), tests run.
6. **Clean up** — only when the user confirms: `workmux merge <name>`
   (merge + delete worktree + close session) or `workmux remove <name> --force`
   (discard).

### Rules

- NEVER run `workmux merge` or `workmux remove --force` without the user
  explicitly confirming — those destroy work.
- `workmux dashboard` is a TUI — don't run it; use the non-interactive commands.
- Agent runs take minutes. Use spawn_subagent with background=true to manage
  the lifecycle so the user conversation stays responsive, and text the user
  when the agent finishes or gets stuck.

## Sending input to plain tmux panes (only when asked)

- `tmux send-keys -t SESSION:WINDOW.PANE "command" Enter`

Never send keys, kill sessions, or interrupt running processes unless the
user explicitly asked. Prefer reporting what you see and proposing the
action.
