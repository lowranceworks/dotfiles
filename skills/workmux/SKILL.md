---
name: workmux
description: Manage git worktrees and tmux windows as isolated development
  environments, and observe or drive terminal panes from the command line —
  read what a pane is displaying (including full-screen TUIs that produce no
  pipeable output), send input to agents and shells, and run commands in
  another pane. Use when the user mentions workmux, worktrees, or parallel
  agent workflows, or asks to run something in a tmux pane, inspect what a
  terminal is showing, drive an interactive program, or open agents in projects.
---

# workmux

workmux manages git worktrees paired with tmux windows for parallel
development. Each worktree is an isolated workspace with its own branch,
terminal state, and AI agent.

**If the user asks you to create worktrees or dispatch tasks (e.g.,
"/workmux add ..."), you are a dispatcher.** Write prompt files and run
commands. Do NOT explore, read, or research the codebase first. Use
context you already have. The worktree agent does all the work.

## Opening agents in projects

When the user asks to open or start a new agent in `<project>`, treat the
project name as a tmux session name. Resolve the project's directory, reuse
that tmux session if it exists, and create it if it does not. Start the agent
in a new window in that session, with the project directory as its working
directory. Use the agent requested by the user or the configured default.
This means a terminal agent in tmux, not a new chat in the assistant app.

For an existing session:

```bash
tmux new-window -d -P -F '#{window_id}' -t <project> -n <name> \
  -c <project-path> <agent>
```

If the session does not exist, create it with the agent in its first window:

```bash
tmux new-session -d -P -F '#{window_id}' -s <project> -n <name> \
  -c <project-path> <agent>
```

Use tmux session metadata to resolve existing project paths, for example
`tmux list-sessions -F '#{session_name}\t#{session_path}'`. Avoid directory
listings when that metadata already supplies the path. Create windows with
`tmux new-window -d -P -F '#{window_id}' ...` to return the new window ID;
use that ID for subsequent operations instead of listing windows again.
When switching is requested, batch the client lookup and switch into one
tool call. Switch only when requested. Avoid redundant verification calls
when the command's successful result already confirms the operation.

When a separate worktree would clearly benefit the task, use `workmux add`
from the target repository instead. Pass `--parent-session <project>` to
place the agent in the intended tmux session. Use the configured default
agent, or pass `-a <agent>` when the user requests a specific agent. Workmux
creates the parent session if needed. Otherwise, use the existing project
checkout.

## Checking agent status

Reuse known sessions, paths, and handles. If handles are unknown, inspect
the session's coordinator or dashboard first.

Batch `workmux status` and `workmux capture <handle> -n 50` for relevant
agents in one tool call. Skip idle shells and unrelated projects. Report
task, progress, blockers, and completion evidence; stop when clear.

## Key Concepts

- **Handle**: the worktree directory name, derived from the branch name
  (slugified). Used to identify worktrees in all commands
- **Worktree directory**: defaults to `<project>__worktrees/<handle>` as a
  sibling of the project root
- **Window prefix**: tmux windows are named `wm-<handle>` by default
  (configurable via `window_prefix`)
- **Agent status**: agents report status via hooks: working, waiting (needs
  input), done (finished)

## Commands

### Create a worktree

```bash
workmux add <branch-name>
```

Creates a git worktree, runs file operations and hooks, creates a tmux
window with configured pane layout, and switches to it.

Key flags:
- `--pr <number|url>`: checkout a GitHub pull request by number or full URL into
  a new worktree. The local branch defaults to the PR head branch name. Pass
  `<branch-name>` to override it, for example
  `workmux add --pr https://github.com/owner/repo/pull/123 custom-name`. Requires
  authenticated `gh`.
- `-b, --background`: create without switching to it
- `-p <text>`: inline prompt for AI agent panes
- `-P <file>`: prompt from file
- `-e, --prompt-editor`: write prompt in $EDITOR
- `-A, --auto-name`: generate branch name from prompt via LLM
- `-a <agent>`: override the agent (can specify multiple for multi-worktree)
- `-w, --with-changes`: move uncommitted changes to the new worktree
- `--base <branch>`: branch from a specific base
- `--name <name>`: override the worktree handle
- `--target-name <name>`: override the workmux-managed tmux window or session name
- `--parent-session <session>`: put a window-mode target in this tmux session,
  creating the parent session when it does not exist
- `-o, --open-if-exists`: open existing worktree if it exists (idempotent)
- `-W, --wait`: block until the tmux window is closed
- `-n, --count <N>`: create N worktree instances
- `--foreach <matrix>`: create worktrees from variable matrix
- `--no-hooks, --no-file-ops, --no-pane-cmds`: skip setup steps

### Create without a multiplexer

```bash
workmux add <branch-name> --headless --json
```

Runs file operations and post-create hooks without creating a window or
starting an agent. No running multiplexer is required. `--json` requires
`--headless` and returns one JSON receipt with the handle, worktree path,
and effective working directory; hook output goes to stderr.

Use an explicit local branch name. Supports `--base`, `--name`, `--no-hooks`,
and `--no-file-ops`, but not PR checkout, prompts, `--background`, or other
mux/agent options. Worktrees persist until removed: clean up with
`workmux remove <handle>` or attach a window later with `workmux open <handle>`.

### List worktrees

```bash
workmux list          # all worktrees
workmux list --pr     # with GitHub PR status
workmux list <name>   # filter by handle or branch
```

Shows branch, agent status, tmux window status, and unmerged commits.

### Merge a branch

```bash
workmux merge                 # merge current branch into main
workmux merge <branch>        # merge specific branch
workmux merge --rebase        # rebase before merging (linear history)
workmux merge --squash        # squash all commits into one
workmux merge --into <branch> # merge into a different target branch
workmux merge --keep          # merge but keep worktree/window/branch
workmux merge --notification  # show system notification on success
```

Merges the branch, deletes the tmux window, removes the worktree, and
deletes the local branch. Use the `/merge` skill for the full workflow
(commit, rebase, then merge).

### Remove worktrees

```bash
workmux remove                # current worktree
workmux remove <name>...      # specific worktrees
workmux rm --gone             # worktrees whose remote branch was deleted
workmux rm --all              # all worktrees
workmux rm -f <name>          # force, skip confirmation
workmux rm --keep-branch      # keep the branch, remove worktree + window
```

### Open / close windows

```bash
workmux open <name>           # open or switch to tmux window
workmux open --new            # force a new window (creates suffix -2, -3)
workmux open <name> -p "..."  # open with a prompt for agent panes
workmux close <name>          # close tmux window, keep worktree
```

### Interact with other agents

These commands target agents by their worktree handle. If the handle is
not found in the current repo, workmux searches all active agents globally.
Use `project:handle` syntax to disambiguate when names collide.

```bash
# Check agent statuses
workmux status                          # all agents
workmux status auth api-tests           # specific agents

# Wait for agents
workmux wait agent-a agent-b            # block until done
workmux wait agent-a --timeout 3600     # with timeout (seconds)
workmux wait agent-a agent-b --any      # wait for first to finish
workmux wait agent-a --status working   # wait for specific status

# Read agent terminal output
workmux capture agent-a                 # last 200 lines (default)
workmux capture agent-a -n 50           # last 50 lines

# Send instructions to an agent
workmux send agent-a "fix the tests"    # short message
workmux send agent-a "/merge"           # send a skill command
workmux send agent-a -f followup.md     # from file
workmux send myproject:docs "update the API section"  # cross-project
workmux send %42 "fix the tests"        # by pane ID (worktrees with several agents)
workmux send --wait agent-a "fix it"    # confirm delivery, wait for done/waiting
workmux send --wait --until working agent-a "fix it"  # delivery confirmation only
workmux send --wait --timeout 600 agent-a -f task.md  # give up after 10 min

# Run shell commands in an agent's worktree
workmux run agent-a -- pytest tests/    # wait and stream output
workmux run agent-a -b -- npm run build # run in background
```

`send` refuses an agent waiting on a dialog (Enter would answer it) and a
worktree with several agents; target one of those by the pane ID that
`workmux status --json` shows. Failures print a stable error name and exit with
its code:

| Error                  | Exit | Meaning                                                |
| ---------------------- | ---- | ------------------------------------------------------ |
| `agent_waiting`        | 3    | Agent is waiting on a dialog; nothing sent             |
| `ambiguous_target`     | 4    | Target matches several agents; pane IDs listed         |
| `agent_not_found`      | 5    | No live agent for the target                           |
| `send_stalled`         | 6    | `--wait`: idle agent showed no activity within 5s      |
| `agent_gone`           | 7    | Agent exited before its turn settled                  |
| `agent_status_unknown` | 8    | Agent has no reported status; not sent                 |
| `timeout`              | 124  | `--wait --timeout` expired                             |

After a `send`, `workmux wait` counts only the agent sent to and only states of
the turn the send started.

### Observing and driving panes

Two layers — pick by target:

- **A workmux-managed agent**: `workmux capture`, `workmux send`, `workmux
  run` (above). They resolve the agent by handle and know the right pane.
- **Any other tmux pane**: raw `tmux`.
  - `tmux capture-pane -p -t <target>` — what the pane is displaying; add
    `-S -` for full scrollback. This is the observation channel for
    full-screen TUIs that produce no pipeable output.
  - `tmux send-keys -t <target> -l "text"` types literal text; without `-l`
    the arguments are key names — `Enter`, `Escape`, `Up`, `C-c`.
  - Target syntax is `session:window.pane`; enumerate with
    `tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}'`.
    `$TMUX_PANE` self-targets when the caller is itself inside tmux.

Rules:

- **Target explicitly.** Handles and full `session:window.pane` targets
  survive layout churn that shifts bare indices; re-list rather than assume.
- **Typed text and key events aren't interchangeable.** `send-keys -l` and
  `workmux send` type text; a control byte (`C-c`) or named key (`Escape`,
  `Up`) needs a real key event. Typed text is only submitted with a trailing
  newline — with tmux, append `Enter` as a separate argument.
- **Wrap redirects in `/bin/sh -c '…'`.** Typed text lands in whatever shell
  runs in that pane, and shells disagree — a bare `>` in the wrong one
  silently writes nothing.
- **Wait for a sentinel, never a sleep.** There is no reliable "is it
  finished" signal to poll:

  ```sh
  rm -f /tmp/done
  tmux send-keys -t "$pane" "/bin/sh -c 'make test; echo ok > /tmp/done'" Enter
  until [ -f /tmp/done ]; do sleep 0.5; done
  tmux capture-pane -p -t "$pane" | tail -20
  ```

  If you poll the screen instead, remember the line you typed is echoed
  there — assemble the marker at runtime (`printf done-%s "$nonce"`) so the
  joined string only ever appears in real output.
- **Killing is destructive — ask first.** `tmux kill-pane`,
  `tmux kill-session`, and `workmux remove` terminate whatever is running in
  them. Never force-close a busy pane without the user's go-ahead.

### Other commands

```bash
workmux path <name>           # print worktree filesystem path
workmux dashboard             # TUI dashboard of all active agents
workmux config edit           # open global config in $EDITOR
workmux config reference      # print default config with all options documented
workmux init                  # generate .workmux.yaml in current project
```

## Configuration

Two levels: global (`~/.config/workmux/config.yaml`) and project
(`.workmux.yaml`). Project overrides global.

### Key options

```yaml
agent: pi                        # default agent for <agent> placeholder
merge_strategy: rebase           # merge, rebase, or squash
mode: session                    # window or session

panes:
  - command: pi                  # agent pane
  - split: vertical              # second pane with shell
    focus: true

files:
  copy:
    - .env                       # copy from main worktree
  symlink:
    - node_modules               # symlink from main worktree

post_create:
  - '<global>'                   # include global hooks
  - npm install                  # project-specific setup

base_branch: develop             # default base for new worktrees
window_prefix: wm-               # tmux window name prefix
```

Use `'<global>'` in project config arrays to include global values.

**Session naming convention (this machine):** the global config sets
`window_prefix: "{project} 󰘬 "`, and `{project}` only resolves to the repo
basename. Before the first `workmux add` in a repo that lacks a
`.workmux.yaml`, create one at the repo root with a parent-qualified prefix
so sessions read `parent/repo 󰘬 branch`:

```yaml
window_prefix: "<parent-dir>/<repo> 󰘬 "
```

Never rename a workmux-managed tmux session by hand to work around this —
workmux recomputes the session name from `window_prefix` for `open`,
`close`, and `remove`, so a mismatched name breaks those commands.

For the full configuration reference with all options documented, run
`workmux config reference`.

### Agent detection

Built-in agents (`claude`, `gemini`, `codex`, `opencode`, `kiro-cli`,
`vibe`) are auto-detected in pane commands and receive prompt injection
automatically. The `<agent>` placeholder resolves to the configured agent.

## Common Workflows

### Finishing work: direct merge

Use `/merge` to commit, rebase onto the base branch, and merge in one
step. This cleans up the worktree, tmux window, and branch.

### Finishing work: PR-based

1. Commit changes
2. `git push -u origin HEAD`
3. Use `/open-pr` to create and verify a draft PR from the task worktree's branch
4. After PR is merged remotely, clean up with `workmux rm --gone`

### Delegating tasks

Use `/worktree` to spin off tasks into parallel worktree agents. The
agent writes a prompt file and runs `workmux add -b -P <file>`.

For full lifecycle orchestration (spawn, monitor, merge), use
`/coordinator`.

### Cross-project worktree creation

`workmux add` creates a worktree in the current working repository. Set the
command's working directory to the target project and pass `--parent-session`
to place the managed window directly in a specific tmux session. The working
directory and tmux session are independent. Background and agent tool
invocations can omit `$TMUX_PANE`, so coordinated dispatch should always pass
`--parent-session` when placement matters. Workmux creates the parent session
when it does not exist, so do not bootstrap it with `tmux new-window` or
`tmux new-session`.

```bash
# Run with the command working directory set to <project-path>
workmux add <branch> -b -P <prompt-file> --parent-session <session>
```

Use `--target-name <name>` only when the managed tmux target needs a name that
differs from the worktree-derived default. Run `workmux` commands from the
target repository so it creates the worktree from the correct Git repository
and base branch.

Do NOT research before dispatching. Use context you already have, but
do not explore or read code just to write the prompt. Worktree agents
can read files from other projects via absolute paths, so reference
other projects by path and let the agent explore on its own.

## Related Skills

- **`/merge`**: commit, rebase, and merge the current branch
- **`/rebase`**: rebase with smart conflict resolution
- **`/worktree`**: delegate tasks to parallel worktree agents
- **`/coordinator`**: orchestrate multiple agents (spawn, monitor, merge)
- **`/open-pr`**: create and verify a draft PR from the task worktree's branch
