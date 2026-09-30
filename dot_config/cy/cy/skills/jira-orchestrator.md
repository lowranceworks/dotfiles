---
name: jira-orchestrator
description: Recurring workflow — watch the INF board, onboard new items into workmux sessions with vault-tracked plans, execute on the user's 'go'
---

# Jira Orchestrator

Runs on the cron schedule `*/15 8-16 * * 1-5` (weekdays 8am-4:45pm local) as
a sub-agent, and interactively whenever the user asks about orchestration.
Uses the `atlassian` skill for Jira and `tmux-ops` for workmux. All
orchestration state lives in the Obsidian vault — NEVER in repos:

```
~/obsidian-vaults/work-vault/20 Projects/In Progress/AI Orchestration/
├── Jira Orchestration.md      # dashboard (dedupe source of truth)
└── INF-XXXX-PLAN.md           # one per item
```

## Per-run workflow (cron firing)

1. **Fetch board**: JQL `assignee = currentUser() AND status != Done AND
   project = INF ORDER BY updated DESC` (see atlassian skill for auth).
2. **Dedupe**: read `Jira Orchestration.md`. Skip items already listed.
3. **Pick at most ONE new item** (the most recently updated). If none, end
   the run quietly — no message.
4. **Fetch issue detail** (summary, description) via
   `/rest/api/3/issue/KEY?fields=summary,description,status,priority`.
5. **Infer repo(s)** from the issue text. Heuristics (check against actual
   repos under ~/projects first — use `ls` to verify names):
   - "port" / "port.io" → internal-org/port-terraform
   - "awx" / "ansible" → internal-org/awx-terraform
   - "gcp" → gcp-projects-terraform / gcp-web-platform-terraform
   - "oci" → oci-infrastructure-terraform
   - "tfe" / "terraform enterprise" → tfe-infra
   - "release flow" → internal-org/release-flow
   - No confident match → say so and ask, proposing nothing.
6. **iMessage the user** (via notify): *"New: INF-XXXX — summary. Proposed
   repo(s): R. Reply to confirm or correct."* Add the item to the dashboard
   with status `awaiting-confirmation`. End the run.

**Dry-run mode**: if the prompt says "dry-run", do steps 1-5 only and report
what you WOULD message — no dashboard writes, no notify.

## On user confirmation (main session, any channel)

When the user replies confirming or correcting the repo(s):

1. `cd <repo> && workmux add inf-xxxx` (session/window per tmux-ops skill).
2. In the worktree: `git fetch --all && git checkout -b INF-XXXX` (from the
   repo's default branch; if the branch exists, check it out).
3. Write `INF-XXXX-PLAN.md` (template below) into the vault — objective from
   the Jira issue, a concrete numbered plan tailored to the repo.
4. Update the dashboard: status `awaiting-go`.
5. iMessage: *"INF-XXXX ready. Plan: <vault path>. Reply 'go INF-XXXX' to
   start, or edit the plan first."*

## On 'go INF-XXXX'

1. Verify status is `awaiting-go`; read the CURRENT plan file (the user may
   have edited it — follow their edits).
2. Update dashboard + plan status to `in-progress`.
3. Spawn a sub-agent (model="task") that:
   - Starts a coding agent in the worktree: `opencode run "<plan contents
     as brief>"` (or sends it to the session's agent window)
   - Checks off plan steps in INF-XXXX-PLAN.md as they complete
   - Appends timestamped entries to the plan's Progress log
   - Updates the dashboard's updated/status columns
   - Notifies the user at milestones, blockers, and completion
4. On `stop INF-XXXX`: halt the worktree agent (`workmux remove` ONLY with
   explicit user confirmation), status `blocked`.
5. On `status INF-XXXX`: reply with the plan's status, remaining unchecked
   steps, and the last progress-log entry.

## INF-XXXX-PLAN.md template

```markdown
# INF-XXXX — <summary>
Jira: <url> | Repo(s): <repo> | Branch: INF-XXXX | Session: wm-inf-xxxx
Status: awaiting-confirmation

## 🎯 Objective
<from the Jira issue description>

## 📋 Plan
- [ ] step 1
- [ ] step 2

## 📝 Progress log
- <YYYY-MM-DD HH:MM> — created; awaiting repo confirmation
```

## Dashboard format (Jira Orchestration.md)

```markdown
# Jira Orchestration

| Item | Summary | Status | Plan | Session | Updated |
|---|---|---|---|---|---|
| INF-XXXX | ... | awaiting-go | [[INF-XXXX-PLAN]] | wm-inf-xxxx | 2026-09-28 14:00 |
```

## Rules

- Jira is READ-ONLY. Never transition, comment, or edit issues.
- NEVER create a worktree before the user confirms the repo(s).
- NEVER execute before an explicit 'go INF-XXXX' from the user.
- NEVER `workmux merge` or `workmux remove --force` without explicit
  confirmation for that specific item.
- One new item per cron run, even if several are untracked.
- The dashboard is the dedupe source of truth — update it atomically with
  each state change (read-modify-write the table row for the item).
