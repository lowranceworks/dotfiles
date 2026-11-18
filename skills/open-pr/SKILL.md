---
name: open-pr
description: Use when the user asks to create, open, make, or submit a GitHub pull request or PR, or when another workflow reaches PR creation.
---

# Open a draft PR

**Every PR this agent creates must start as a draft.** Passing tests, completed
review, urgency, or a request to "make a PR" never imply ready-for-review status.
Do not automatically mark a PR ready after creating it.

## Establish the PR worktree

**REQUIRED SUB-SKILL:** Use `workmux` before preparing the PR.

1. Inspect `workmux list` and `git worktree list`. Reuse the task's existing
   worktree when present, including the current one; do not nest or duplicate
   it. Otherwise create it with **workmux**, not raw `git worktree add`.
2. Follow repository/global naming: Jira branch `INF-1234`, worktree handle
   `INF-1234-<verb-first-feature-slug>`; without a key, use the feature slug.
   For same-agent execution, provision without spawning another agent:
   `workmux add "$branch" --name "$handle" --base "$start" --headless --json`.
   Select `start` to retain completed commits, not blindly the PR base. Reuse
   an existing task branch when unoccupied. Never force it out of another
   active checkout; reuse its task worktree or ask how to relocate it safely.
   If it occupies the original main checkout, stop and ask before freeing it;
   do not invent an alternative PR head to bypass the occupied branch.
3. Resolve the real path from the receipt's `worktree_path` or
   `workmux path "$handle"`. Transfer only reviewed task-owned pending edits;
   ask if mixed scope makes that unsafe. A new worktree does not copy dirty
   changes. Do not combine `--headless` with `--with-changes`.
4. Run all following inspection, commits, tests, pushes, and `gh` commands
   **in that worktree**, using an explicit working directory on every tool
   call (a prior shell `cd` does not persist). Derive `branch` with
   `git -C "$worktree" branch --show-current`; require the intended feature
   branch, not a detached HEAD or the PR base. Confirm its diff contains the
   completed work before pushing. Use that exact branch as the PR's `--head`.

If workmux is unavailable or provisioning fails, stop and report the blocker;
do not fall back to the original checkout or raw Git worktree creation.

## Prepare (in the task worktree)

1. Read repository instructions and any PR template. Confirm the repository,
   remote, head branch, and intended base; discover the default rather than
   assuming `main` or `master`.
2. Check `git status`, then inspect `git diff <base>...HEAD`,
   `git log <base>...HEAD --format="%s"`, and changed files. Use conversation
   context to explain the intent, not just restate the diff.
3. If relevant changes are uncommitted, review and commit only the intended
   scope under repository conventions. Ask if ownership/scope is unclear;
   never sweep unrelated user changes into a commit.
4. Check for an existing open PR for this head/base. Reuse an existing draft
   instead of creating a duplicate. If it is already ready for review, stop
   and report its status; do not silently change it or create another PR.
   Distinguish "no PR" from authentication/API failures.
5. Run the applicable verification and report its actual results. Do not invent
   passing tests. Push the intended branch to the confirmed remote, setting
   its upstream if needed; do not force-push by default.

## Write the description

Use the repository's PR template. Otherwise, write a temporary body file with:

```markdown
## Summary
[1–2 sentences explaining what changed and why]

## Changes
- [Key changes]

## Testing
[Commands run and observed results, or what was not run and why]
```

Keep the title concise (at most 72 characters unless the repository says
otherwise). Include before/after evidence for UI or performance changes.

## Create and verify

With the resolved `worktree`, `base`, `title`, and `body_file` prepared:

```bash
cd "$worktree" || exit 1
branch=$(git branch --show-current)
pr_url=$(gh pr create --draft --base "$base" --head "$branch" \
  --title "$title" --body-file "$body_file") || exit 1
gh pr view "$pr_url" --json url,isDraft,state,headRefName
```

Read the JSON. Report success only when `isDraft` is `true`, `state` is `OPEN`,
and `headRefName` matches the worktree's branch; return the URL and explicitly
say **draft PR**. Verify an existing draft the same way before reusing its URL.

If creation or verification fails, or drafts are unsupported, stop and report
the blocker. A non-draft result is a policy mismatch, not successful completion.
Never retry by dropping draft mode or silently create a replacement PR.

## Quick reference / common mistakes

| Situation | Required behavior |
|---|---|
| PR workspace | Create with workmux or reuse the task worktree; push and use its branch as `--head`. |
| CLI creation | Always include `--draft`; do not use browser-only `--web` creation. |
| API or another creation tool | Explicitly set `draft: true` and verify the resulting status. |
| "It is tested / urgent / ready to ship" | Still create a draft; do not promote it automatically. |
| Draft unavailable or status unknown | Report the blocker, not a ready PR or an unverified success. |

**Red flags:** bypassing workmux, wrong checkout/head branch, omitted task
commits, missing draft mode, browser handoff presented as creation, skipped
status verification, or automatically marking ready after creation.
