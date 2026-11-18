---
name: fan-out
description: Fan a batch of tickets out into parallel agent sessions — one git worktree per ticket, each opened as a workmux session with the agent's implement command staged. Use when the user asks whether tickets can be worked in parallel, wants worktrees or agent sessions for several tickets at once, or says to fan out / spin up a batch.
---

# Fan Out

Stand each parallel ticket up as its own agent session: an isolated worktree, a workmux-managed tmux session rooted there with the agent launched, and that ticket's `/implement` staged in its input. This session stays put and never enters a worktree.

A fan-out is only as good as its set. Two tickets that must share a file, a path, or a name are not parallel, however independent they look; fan them out anyway and the collision surfaces later as a merge rather than now as a decision. So the job is three moves: prove the set is parallel, cut a worktree per ticket, stage the command in each agent pane.

## 1. Prove the set is parallel

Fetch and fast-forward the trunk worktree first (`git fetch origin --quiet && git pull --ff-only`, run from the trunk worktree). Both this step's own exploration and step 2's `--base <trunk>` read the trunk worktree's checked-out files, not just its refs — a `git fetch` alone leaves them stale. Skip this and a wave check can clear a collision that a PR merged since you were last here already created, the same way this section exists to catch. A pull that fails (dirty tree, diverged history) means the trunk worktree isn't fit to fan out from yet — resolve that before cutting anything, don't route around it.

Start from the **frontier**: the tickets that are open with no open blocker. If the repo documents its own frontier query or wave check, use it — a repo's ticket-slicing note is the authority over this section's general shape.

Wave-check the frontier for the two collisions: tickets that _create_ the same foundation (a manifest, a lockfile, a workflow, a package layout), and tickets that must agree on a path, name, or surface that no ticket decides. Either one means the frontier is not yet the wave.

When the check fails, fix the tracker before cutting worktrees, so no branch is built on a foundation that is about to move:

- **Foundation collision** → land the foundation first, or widen one ticket to own it.
- **Undecided shared interface** → add a small contract ticket the others block on.
- **Human prerequisite** (a credential, a dashboard step) → a `ready-for-human` ticket, kept off the agent branches.

Record each remedy as a real blocking edge, so the tracker's own frontier query reflects it.

A third pattern doesn't gate this step. An additive registry built for exactly this — a list or struct a caller assembles once and callees register into, so no ticket creates a foundation — still has one call site that wires every registration in: the constructor or builder literal that hands the assembled value to its caller. Two tickets in the wave each adding one field or line there will conflict when the second merges, purely from landing near the same lines (a formatter realigning the literal is enough). Unlike the two collisions above, this is a cheap `git rebase` for whichever PR lands second, not a design decision — note it when you present the wave rather than fixing the tracker to dodge it.

**Done when** every ticket you are about to fan out has no open blocker, and every ticket you are holding back carries an edge naming its blocker.

## 2. Cut a worktree per ticket

One worktree per ticket off the trunk, named `issue-<number>-<slug>` so its path traces back to the ticket:

```sh
workmux add issue-<n>-<slug> --base <trunk> -b
```

One command does the whole stand-up: branch and worktree, a tmux session rooted at the worktree, and the configured agent (pi) launched in its first pane. `-b` is the point: you are spawning siblings, not switching into one — this session stays in the trunk worktree. The branch name slugifies into the workmux handle used to target everything later. Let the configured hooks run (file copies, `post_create`) rather than passing `--no-hooks` on your own judgement; the setup they do is part of what makes each worktree usable.

**Done when** `git worktree list` shows exactly one clean worktree per ticket, each on its own branch off the trunk, and `workmux list` shows a session per ticket.

## 3. Stage the command in each agent pane

Per worktree: wait for the agent to come up in its worktree, then stage that ticket's `/implement` unsubmitted.

```sh
session=$(tmux list-sessions -F '#{session_name}' | grep -- "issue-<n>-<slug>")
pane=$(tmux list-panes -t "$session" -F '#{pane_id} #{pane_current_command}' | awk '$2=="pi" {print $1}')
tmux send-keys -t "$pane" -l "/implement #<n>"
```

Three rules make the targeting reliable (the `workmux` skill has the CLIs' own mechanics):

- **Target by pane id, not by index.** `%N` ids are stable; `window.pane` indices shift the moment a layout changes, so a command aimed by index can land in a pane you were not aiming at.
- **`-l` types literal text and nothing else.** No trailing `Enter` argument is exactly what keeps the command staged rather than submitted. `workmux send` and `workmux add -p` are the wrong tools here — they _submit_ the prompt, and their automatic prompt injection only applies to workmux's built-in agents, which pi is not.
- **Wait for the agent's own footer before staging.** Poll `tmux capture-pane -p -t "$pane"` for the line naming the worktree — that footer is the readiness signal. `workmux status` is advisory at best: its agent-status hooks only understand the built-in agents, so a pi pane may never report. And remember the line you staged is echoed on screen — if you poll for output rather than the footer, assemble any marker at runtime so it only ever appears in real output.

**Done when** each ticket has exactly one session, with the agent idle at its worktree and `/implement #<n>` staged but unsubmitted. Leave the commands staged: the human pressing Enter in each session is what starts the work, which keeps the fan-out itself from writing any code.

## Teardown

Tearing down after merge is workmux's own job, one branch at a time — `workmux merge <handle>` merges and removes the session, worktree, and branch; `workmux rm --gone` cleans up worktrees whose remote branch was deleted. Not a byproduct of the next fan-out.
