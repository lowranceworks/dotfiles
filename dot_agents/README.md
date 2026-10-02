# dot_agents

Homegrown agent skills, deployed by chezmoi to `~/.agents/skills/` (the `dot_`
prefix maps to a dotfile in `$HOME`).

`~/.agents/skills/` is a global skill-discovery directory that multiple coding
agents — pi, Claude Code, Codex, and any other agent following the
[agents/skills convention](https://agentskills.io) — read automatically. No
`settings.json` entry is required for any of them.

## Skills

Each skill is a directory with a `SKILL.md` (YAML frontmatter with `name` and
`description`, followed by instructions):

| Skill               | Purpose                                                            |
| ------------------- | ------------------------------------------------------------------ |
| `github-app-token`  | Mint tokens via a GitHub App                                       |
| `cleanup-branch`    | Git branch cleanup helper                                          |
| `split-commits`     | Split work into clean commits                                      |
| `release-please`    | Release automation helper                                          |
| `go-ci`             | Go CI maintenance                                                  |
| `repo-hardening`    | Apply repo rulesets (carries `RULESET-PAYLOAD.json`)               |
| `fan-out`           | Fan tickets out into parallel worktree + Macterm agent tabs        |
| `macterm`           | Macterm terminal workflows                                         |
| `argocd-akuity`     | ArgoCD/Akuity helper — **mlb-only**                                |

## Why these live in-repo

Keeping them here means edits land as ordinary chezmoi commits, and
`up skills`' blanket `skills update -g -y` cannot silently overwrite a local
tweak with an upstream version. Third-party skills (e.g. mattpocock/skills)
are fetched separately by `run_onchange_after_15-install-agent-skills.sh.tmpl`.

## Profile gating

`argocd-akuity` is mlb-only: `.chezmoiignore` drops `.agents/skills/argocd-akuity`
when `not .mlb` (same pattern as `Brewfile.mlb`).

**Caveat:** ignoring a path is permanent for any already-deployed copy —
`.chezmoiremove` cannot remove an ignored target. If `argocd-akuity` ever got
applied on a personal machine, it must be deleted from `~/.agents/skills/`
manually.
