# Unified Skills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Install custom and upstream skills through one CLI for Pi.
**Architecture:** Root `skills/` collection, templated local Git source, shared
`agents` target. Chezmoi keeps configuration ownership; skills owns installs.
**Tech Stack:** Markdown, TOML/chezmoi templates, Bash, skills v0.2.1, Python unittest.
**Spec:** `docs/superpowers/specs/2026-11-18-unified-skills-design.md`

## Global Constraints

- Use committed local Git content; no push is required or authorized.
- Target `~/.agents/skills` only; no parallel Pi-native installation.
- Back up installed skills/locks; no default pruning or pool removal.
- Preserve existing custom behavior and pending draft/workmux guidance.
- Execute in the current checkout; local commits are required for installation.

## Review Focus

- Collection discovery must work without per-skill manifest entries.
- Local source paths must render correctly on different source checkouts.
- Failed upstream resolution must not remove installed skills.
- Pi-local duplicates must not shadow the canonical source or lose guidance.
- Commit-only deployment and feature-worktree limitations must be explicit.

### Task 1: Transfer ownership and apply the committed collection

**Files:** Move `dot_agents/skills/` to `skills/`; replace the old deployed README
with `skills/README.md`. Template `dot_config/skills/skills.toml.tmpl`. Modify
`.chezmoiignore`, `.chezmoiscripts/run_onchange_after_15-skills-sync.sh.tmpl`,
`dot_pi/agent/AGENTS.md`, `README.md`, `docs/skills.md`. Add
`docs/tests/test_skills.py`. Carry prior draft/workmux changes and plan records.

**Interfaces:** Consumes local committed HEAD and upstream Git sources; produces
one shared CLI-managed pool and no chezmoi-owned skill definitions.

- [x] Write and run failing real-boundary tests for rendering, collection
  installation, chezmoi ownership, dirty-edit exclusion, and non-pruning failure.
- [x] Move definitions, preserve Pi-local additions, and update manifest/hook.
- [x] Update instructions/docs; test PR workmux behavior with fresh Pi samples.
- [x] Run all `docs/tests` tests and read the complete results.
- [x] Obtain read-only standards/spec review and fix material findings.
- [x] Back up affected runtime pools and lockfiles outside discovery.
- [ ] Commit source/configuration changes locally; do not push.
- [ ] Preview/apply only manifest + Pi instructions, then run non-pruning sync.
- [ ] Archive identified Pi-local duplicates; verify installed file equality,
  lock ownership, unchanged non-Pi copies, and normal Pi discovery.
- [ ] Record results and verify the final Git/deployed state.

Pre-flight: one task owns the shared foundation; no parallel implementation.
All initial dirty changes are from this session. Existing checkout is `latest`.

## Evidence before deployment

Four new integration tests failed for the expected old behavior, including a
real isolated reproduction of `--prune` deleting an installed skill after a
source failure. After the migration changes, the full `docs/tests` suite passed
7/7. The collection test installs all 19 committed custom skills with the real
CLI in an isolated HOME, rejects dirty/untracked edits, and preserves the JSON
supporting asset. `git diff --check` and rendered Bash syntax checks passed.

Backups: `~/.local/state/skills/backups/unified-20261118T144726/` contains the
shared, Pi-native, Claude, Codex, and Hermes pools/locks, live manifest/Pi
instructions, and pre-migration working diff. No runtime copies removed yet.

Preservation: merged Pi-local coordinator/merge additions and workmux project
agent/status/send guidance into the collection, retaining repository-specific
Pi defaults, tmux observation, and session naming. Existing duplicate rebase
and worktree definitions were identical. The workmux PR links now describe
draft creation, not the superseded browser handoff.

PR behavior: five old-skill controls bypassed workmux; five updated samples
used workmux, preserved `INF-5014` commits, worked from its resolved worktree,
created drafts, and verified head/status. Existing-worktree, mixed dirty edits,
and workmux-failure scenarios complied. The occupied-branch sample initially
invented an alternate head; added an explicit stop/ask rule and reran it to
confirm no alternate head or checkout mutation. Logs:
`/tmp/pi-open-pr-workmux.qzz4p2/`.

Review: spec axis found no deviations. Standards found fixture Git inherited
ambient repository overrides before HOME isolation. A new regression test
reproduced mutation of an unrelated temporary repo's Git config; fixture Git
now always uses isolated HOME/config/templates with inherited GIT_* overrides
removed. The regression and full suite passed (8/8). No material findings
remain. Non-Pi pools will remain untouched by the non-pruning shared-only sync.
