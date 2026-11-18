# Global agent notes

## Pull requests

Whenever asked to create/open/make a PR, use the `open-pr` skill. Every PR this
agent creates must be a **draft**, including PRs created by other skills,
subagents, scripts, or API tools: use `gh pr create --draft` or explicitly set
`draft: true`. Verify GitHub reports `isDraft: true` before claiming success.
Passing tests, urgency, or a generic request to make a PR never authorize a
ready-for-review PR. Do not automatically mark it ready afterward. If draft
creation is unsupported or verification fails, stop and report the blocker;
never fall back to a ready PR.

## Changing a skill's behaviour

All session skills in `~/.agents/skills/` are installed by the `skills` CLI
from `~/.config/skills/skills.toml`. Pi discovers that shared pool natively;
do not create duplicate copies in `~/.pi/agent/skills/`. Never edit installed
skills: sync/update can replace them.

Homegrown definitions live in the dotfiles repository at `skills/<name>/`.
Edit there, commit the changes, then run `skills sync` and `/reload` in Pi.
The manifest uses the committed HEAD of the configured chezmoi source repo;
no push is needed, but dirty edits are not installed. For feature-worktree
edits, merge into that source checkout first or explicitly point a temporary
manifest at the committed feature worktree.

For upstream behavior changes, in preference order:

1. Add a project-specific rule to that project's `AGENTS.md`.
2. Add it to this file if it holds in every project (still deployed by chezmoi).
3. Override or fork the upstream source in
   `dot_config/skills/skills.toml.tmpl`; never rely on same-name install ordering.
4. Add a uniquely named homegrown skill to `skills/`.

Run `chezmoi apply` for manifest/Pi configuration changes. It also syncs skills
after the manifest or committed source HEAD changes. Sync is non-pruning by
default; do not add `--prune` casually (source failures can remove installs).
Upstream a change only when it is generally useful and you will maintain it.

## Subagent dispatch

- **Code review.** `/code-review` splits into two axes. Dispatch both in parallel
  with the `subagent` tool, passing the skill's step-4 brief as each task's
  `task`: standards → `code-review-standards`, spec → `code-review-spec`. The two
  agents are read-only and role-scoped. Without a `subagent` tool, run both axes
  inline in sequence and say so in the report.
- **Research.** Dispatch to the `research` agent with the `subagent` tool, passing
  the question and any constraints (trusted sources, destination path, output
  format) as the task. It leaves one cited Markdown artefact, reports the path,
  and writes nothing else in the worktree.

## Ticket slicing

Before presenting or publishing tickets — and before calling any group parallel
— run the **wave check** on every ticket in the group:

- **Foundation collision.** Two tickets create the same foundation (module
  manifest, lockfile, package layout, CI workflow, config root). Land the
  foundation first, then stack the dependents on it; one foundation cannot ride
  two branches.
- **Undecided shared interface.** Two tickets must agree on a path, name, or
  surface that no ticket or spec decides. Widen the foundation ticket to own it,
  or add a contract ticket and the blocking edges.

Then **state the wave as it actually is** — "one ticket alone, then two in
parallel" — not as it appears by domain. Claimed three-way parallelism that is
really one-plus-two invites worktree collisions.

If the repo has its own ticket-slicing doc (e.g. `docs/agents/ticket-slicing.md`),
read it for the full checklist and worked examples.

## Worktree naming

Name every worktree with the Jira key first, then the feature change being
made: `INF-1234-<feature-slug>` (e.g. `INF-5014-import-tfe-workspaces`;
slug lowercase kebab-case, 2–5 words, verb-first). The branch stays the bare
key (`INF-1234`) unless the repo says otherwise; with workmux use
`workmux add INF-1234 --name INF-1234-<feature-slug> --base <default-branch>`.
No Jira key → the feature slug alone.
