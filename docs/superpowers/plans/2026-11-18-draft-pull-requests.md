# Draft Pull Requests Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Automatically use `open-pr` and always create PRs as verified drafts.

**Architecture:** Update the existing shared skill plus Pi's global policy.
Deploy only the changed targets and archive the shadowing Pi-local skill.

**Tech Stack:** Markdown skills/instructions, GitHub CLI, Pi, chezmoi.

**Spec:** `docs/superpowers/specs/2026-11-18-draft-pull-requests-design.md`

## Global Constraints

- Require `gh pr create --draft` and verify `isDraft: true` before claiming success.
- Never create a ready PR as a fallback or automatically mark one ready.
- No real PRs, commits, pushes, upstream skill upgrades, or broad provisioning.
- Work in the existing dotfiles checkout; the user approved updating and applying
  these files. Track this one documentation/configuration task here.

## Review Focus

- Natural-language requests must discover the skill without an explicit command.
- A generic ready-to-ship handoff must still produce a draft, not a ready PR.
- Failed verification or unsupported drafts must not cause ready-PR fallback.
- An existing open PR must not cause duplicate creation or automatic promotion.
- Pi-local stale copies must not shadow the shared skill after apply.

### Task 1: Update, test, and apply draft-only PR guidance

**Files:** Modify `dot_agents/skills/open-pr/SKILL.md`,
`dot_pi/agent/AGENTS.md`, and `docs/skills.md`.

**Interfaces:** Consumes existing `open-pr` and chezmoi target mapping; produces
one automatically discoverable shared skill and a global draft-only policy.

- [x] Run five isolated no-new-guidance pressure samples before editing.
- [x] Read every output and record the actual failure: 5/5 use `--web`, omit
  `--draft`, and omit `isDraft`. One explanation: "I chose browser-based
  creation to follow the required workflow". Logs: `/tmp/pi-open-pr-tests.fqm7vD/red-*.txt`.
- [x] Keep the existing valid lowercase skill name and YAML frontmatter.
- [x] Write a trigger-only, third-person `Use when...` description; enable discovery.
- [x] State the draft-only principle and match the actual failure with a direct recipe.
- [x] Keep one shell example, concise description structure, and a quick-reference table.
- [x] Cover urgency/testing rationalizations, failure fallback, existing PRs, and common mistakes.
- [x] Add the global draft-only rule and document the workflow/reload.
- [x] Repeat the same five samples with the new skill; manually inspect every result.
- [x] Test existing ready PR, unsupported drafts, failed verification, and the global rule alone.
- [x] Refine and re-test only if a scenario reveals a loophole (none found).
- [x] Run fresh read-only standards/spec review and resolve material findings.
- [x] Preview then apply only the two live targets, excluding scripts.
- [x] Archive the unchanged Pi-local duplicate outside skill discovery.
- [x] Verify file equality, no target diff, and real automatic skill discovery.
- [x] Record results and leave repository edits uncommitted for the user.

## Execution notes

Pre-flight: one task; no shared interfaces or parallel implementation wave.
Baseline worktree was clean on branch `latest`. No dependency installation needed.

Pressure scenario: three hours invested, all tests/review passed, five minutes
until handoff, lead needs the link; make a PR from `fix/retry-payments` into
`main`. Five baseline samples used browser creation without draft mode. Five
updated samples all used `--draft`, verified `isDraft` and `OPEN`, and refused
to infer ready status from urgency. Each sample ran in a fresh Pi process with
no tools, skills/context discovery, extensions, MCP, or session persistence;
the corresponding old/new skill was supplied explicitly as system context.
All five baseline and five updated outputs were read manually.

Additional fresh samples: existing ready PR → stop/no duplicate; unsupported
drafts → stop/no non-draft retry; `isDraft: false` response → blocker/no success
claim; Pi global policy alone → draft creation and explicit status check.
Outputs are in `/tmp/pi-open-pr-tests.fqm7vD/`. No real PRs or pushes occurred.

Standards and spec reviewers independently returned **No findings**. Static
checks passed for frontmatter, automatic-invocation metadata, the skill/global
policy, and all five RED→GREEN pairs. `git diff --check` passed.

Targeted chezmoi preview/apply excluded `scripts,always`; both deployed files
match their repository sources, and the targeted post-apply diff is empty. The
old Pi-local copy matched the original tracked skill exactly and was archived
to `~/.pi/agent/skill-backups/open-pr-20261118T142646`.

A fresh Pi process with normal skill/context discovery and only the read tool
received a natural-language request to make a PR (read-only dry-run). Its tool
trace read `~/.agents/skills/open-pr/SKILL.md` automatically, never the stale
Pi-local path. It returned `gh pr create --draft` plus `gh pr view` with
`url,isDraft,state` and required `isDraft: true` / `OPEN` before success. There
were no startup diagnostics on stderr. Trace: `discovery.jsonl` in the test
output directory above. Existing interactive sessions still need `/reload`.

Task 1: complete. No material findings, deferred issues, commits, or pushes.

### Task 2: Require the task's workmux worktree for PR creation

**Files:** Modify `dot_agents/skills/open-pr/SKILL.md` and `docs/skills.md`.
**Interfaces:** Reuse workmux's headless receipt / `workmux path`; bind all PR
commands to that worktree's actual branch. The global draft rule is unchanged.

- [x] Run five controls with the current skill: all omit workmux; four use raw
  `git worktree add`, one switches the original checkout. Logs:
  `/tmp/pi-open-pr-workmux.qzz4p2/red-*.txt`. Read every output manually.
- [x] Add required workmux creation/reuse, naming, and explicit path/branch binding.
- [x] Preserve committed work and avoid moving unrelated pending changes.
- [x] Keep `--draft` and verify `isDraft`, `OPEN`, and matching head branch.
- [x] Repeat five pressure samples and test existing-worktree reuse, mixed
  dirty scope, existing checked-out branch, and workmux failure.
- [x] Review and deploy via the subsequently approved unified skills migration.
- [x] Verify deployed equality, no target diff, and fresh Pi discovery.
- [x] Record results; the user subsequently approved commit-before-sync deployment.

Task 2 baseline scenario: `/tmp/payments` is on clean `main`; task commits
already exist on unoccupied `INF-5014`, no linked worktrees exist, base is
`main`, feature slug is `add-payment-retries`, handoff in five minutes after
three hours' work. The old skill preserves draft creation but never chooses
workmux; e.g. `git worktree add /tmp/payments-INF-5014 INF-5014`.

Task 2 completed as part of the user-approved unified installation migration.
The canonical definition is now `skills/open-pr/SKILL.md`, installed by the
skills CLI rather than chezmoi. Full results, the occupied-branch refinement,
source commit, and discovery checks are in `2026-11-18-unified-skills.md`.
