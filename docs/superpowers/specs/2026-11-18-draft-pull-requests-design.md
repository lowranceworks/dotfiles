# Draft-only pull request creation

## Approved design

When asked to make/open/create a PR, Pi should automatically load `open-pr`
and create a **draft** pull request. The user approved this approach in the
conversation. This is a small update to the existing homegrown skill, not a
new integration or an upstream skill change.

## Approaches

- **Chosen: update `open-pr` and Pi's global instructions.** Keeps the existing
  name, makes it automatically discoverable, and covers other PR-producing
  workflows with the same draft-only rule.
- A second skill would compete with the existing skill and could be shadowed.
- A tool-blocking extension would add executable enforcement and maintenance
  beyond this requested skill/configuration change. Instructions guide the
  agent; they are not a technical permission boundary.

## Requirements and constraints

- Remove `disable-model-invocation: true`; describe natural-language PR triggers.
- Require `gh pr create --draft`, not browser-only creation, and verify
  `isDraft: true` against GitHub before reporting successful draft creation.
- Never infer permission to mark a PR ready from passing tests, urgency, or a
  generic request to make a PR. Do not silently fall back to a ready PR if
  drafts are unsupported or creation/verification fails.
- Preserve the concise Summary / Changes / Testing description and repository
  templates. Inspect the base, branch, diff, and actual test evidence first.
- Avoid duplicate PR creation or blindly committing unrelated dirty files.
- Add the global policy to `dot_pi/agent/AGENTS.md` so other workflows also use
  draft creation. No upstream skill modifications.
- Deploy the two changed files with a targeted chezmoi apply. Move the identical,
  unmanaged `~/.pi/agent/skills/open-pr` copy outside discovery rather than
  deleting it. Keep the shared `~/.agents/skills/open-pr` as the single source.

## Verification and non-goals

Use isolated, tool-disabled Pi runs for baseline and updated pressure scenarios;
never create a real test PR. Check skill metadata, deployed file equality, and
normal Pi skill discovery. No commits, pushes, upstream skill upgrades, other
skill cleanup, or repo-wide provisioning are part of this task. Reload Pi after
deployment so an existing session refreshes its instructions and skill metadata.

## Follow-up: PR worktree (user request)

The user additionally requires `open-pr` to use workmux to create a worktree
and use that worktree/branch for the PR. Extend the existing workflow; raw
`git worktree add` and PR creation directly from the original checkout do not
satisfy this requirement. Reuse an existing task worktree instead of creating
a redundant one. Use the existing workmux skill and naming conventions.
Headless provisioning lets the current agent continue without spawning an
unrequested agent or switching tmux focus.

Preserve completed commits and transfer only task-owned pending edits safely.
Resolve the real worktree path and branch, perform PR preparation there, push
that branch, and use it explicitly as the draft PR head. A new worktree from
the default base alone must not omit work already committed elsewhere. Stop
on unsafe relocation or workmux errors rather than silently bypassing it.
Apply the updated shared skill; this request is not an instruction to create
an actual PR or task worktree for the dotfiles changes themselves.
