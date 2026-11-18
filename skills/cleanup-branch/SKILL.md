---
name: cleanup-branch
description: Clean up a branch and everything around it — its worktree, its tmux session, its remote ref, and its local branch. Use when the user wants to clean up after a PR is merged, or mentions "delete worktree" or "delete branch".
---

# Cleanup Branch

Remove a branch once its PR is merged: its worktree, its tmux session, the local branch, and the remote ref.

## Workflow

### 1. Find the branch and its PR

Run `git rev-parse --show-toplevel` to get the current worktree path.
Run `git worktree list` to find all worktrees.

Find the default branch:

```sh
gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
```

Identify the **main worktree** as the one whose branch matches the default branch.

If the current worktree IS the main worktree, enumerate all non-main worktrees and look up their associated PRs. For each non-main worktree, prefer running from within that worktree's directory when possible:

```sh
gh pr view --json number,state,mergedAt,title,headRefName
```

If the worktree path is outside the project root (not usable as a `cd` target), fall back to querying by branch name from the main worktree — include `--state all` to catch merged PRs:

```sh
gh pr list --head <branch> --state all --json number,state,mergedAt,title,headRefName
```

Present a table of results to the user:

| #   | PR  | Title         | State  | Worktree path     |
| --- | --- | ------------- | ------ | ----------------- |
| 1   | #42 | Fix login bug | MERGED | /path/to/worktree |
| 2   | #39 | Old branch    | MERGED | —                 |

Include all PRs found — merged, open, and those with no associated PR (show "—" for PR and title). Show "—" for worktree path when no worktree exists for that branch. Then ask: "Which branch should be cleaned up? (enter row number or PR number)" Resolve the selection to a `headRefName`, worktree path (or none), and continue from step 2.

### 2. Check for uncommitted changes

Run `git status --porcelain`. If output is non-empty, warn:

> "Uncommitted changes detected in this worktree. Stash or commit them, or use `workmux rm -f` to discard."

Abort unless the user explicitly chooses `--force`.

### 3. Verify the merge

Run:

```sh
gh pr view --json number,state,mergedAt,title,headRefName
```

- If `state` is not `"MERGED"`, abort: "PR #N is not merged (state: STATE). Aborting."
- Record `headRefName` (branch) and `number` for later steps.

### 4. Switch to the main worktree

All remaining steps must run from the main worktree. Use the main worktree path as the `cd` parameter for every subsequent terminal call.

Verify you are in the right place:

```sh
git rev-parse --abbrev-ref HEAD
```

This should print the default branch name (e.g. `main`).

### 5. Pull the main worktree

From the main worktree path, check whether an `upstream` remote exists:

```sh
git remote | grep -q upstream && echo yes || echo no
```

If `upstream` exists, pull from it explicitly:

```sh
git pull upstream <default-branch>
```

Otherwise:

```sh
git pull
```

### 6. Confirm before deleting

Show the user exactly what will be removed:

- Branch: `<headRefName>`
- Worktree path: `<path>` (or "none")
- workmux session: the session for handle `<handle>` (or "none")

Ask: "Delete branch `<branch>`[and remove worktree at `<path>`]? (y/N)"

Abort if the user declines.

### 7. Quit its agent gracefully

Quit the agent in the worktree's tmux session before the session and directory go away (the `workmux` skill has the CLI mechanics). Resolve the handle from `workmux list`, find the agent pane, and send the quit keys:

```sh
session=$(tmux list-sessions -F '#{session_name}' | grep -- "<handle>")
pane=$(tmux list-panes -t "$session" -F '#{pane_id} #{pane_current_command}' | awk '$2=="pi" {print $1}')
tmux send-keys -t "$pane" C-c   # clear any staged input first
tmux send-keys -t "$pane" C-d   # pi exits on Ctrl-D when the input is empty
```

Quitting first avoids killing a live process with the session teardown: pi exits on Ctrl-D (its `app.exit`, when the input is empty), which hands the pane back to its shell. If the input held text, Ctrl-D edits instead — hence the Ctrl-C first. If the agent is mid-turn it won't exit promptly; surface that to the user rather than tearing down around it, which kills the process.

### 8. Remove the worktree and/or branch

**If a worktree exists** — use workmux, which closes the tmux session, removes the worktree, and deletes the local branch in one step:

```sh
workmux rm <handle>
```

The handle is the slugified branch name — confirm it in `workmux list` rather than deriving it by hand.

Fallbacks:

- **Dirty worktree:** `workmux rm -f <handle>` (force, skips confirmation)
- **Squash-merged / unmerged branch:** if workmux declines to delete the branch, offer `git branch -D <branch>` after the worktree is gone

**If no worktree exists** — just delete the local branch:

```sh
git branch -d <branch>
```

If `-d` fails (squash-merge), offer: `git branch -D <branch>`.

Alternatively, for bulk cleanup of all merged branches at once:

```sh
gh poi --state merged --dry-run   # preview
gh poi --state merged             # delete
```

Use `gh poi lock <branch>` to protect any branch that should be kept.

### 9. Delete remote branch

Runs for both paths — no-op if GitHub already deleted it:

```sh
git ls-remote --heads origin <branch> | grep -q . && git push origin --delete <branch> || true
```

### 10. Report what was done

Note the branch deleted, and the worktree and session removed (if applicable).

## Completion criterion

The branch is gone locally and from `origin`, its worktree no longer appears in `git worktree list`, and no tmux session is rooted at its path.
