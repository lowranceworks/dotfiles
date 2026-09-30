# Agent skills management

How skills are organized in this repo — three kinds of skills, three
mechanisms. Modeled on [mgoodness/dotfiles](https://github.com/mgoodness/dotfiles).

| Kind | Examples | Where they live | How they're deployed | How they update |
|---|---|---|---|---|
| **Homegrown** (you write/edit) | the skills in `dot_agents/skills/` | this repo | chezmoi → `~/.agents/skills/` | ordinary git commits |
| **Third-party** (upstream repos) | `antonbabenko/terraform-skill`, `obra/superpowers` | declared in `.chezmoidata/agent-skills.toml` | pinned `skills` CLI via `.chezmoiscripts/run_onchange_after_15-install-agent-skills.sh.tmpl` → same `~/.agents/skills/` | `npx skills@1.7.0 update -g -y`, on your schedule |
| **App-owned** (one tool's config) | cy's slack/tmux-ops/jira skills | `dot_config/cy/skills/` | chezmoi → `~/.config/cy/skills/` | commits, with the app |

## Why this split works

- **One discovery point.** Everything session-facing lands in
  `~/.agents/skills/` — pi discovers it natively, kimi-code picks it up via
  `extra_skill_dirs = [ "~/.agents/skills" ]` in `~/.kimi-code/config.toml`,
  and any other harness honoring the shared-skills convention sees it too.
  Homegrown and third-party coexist there without colliding: chezmoi manages
  only its own entries, the skills CLI only its own installs.
- **No stale vendoring.** Third-party skills are someone else's moving
  target — declare them, don't copy them. (Vendoring `terraform-skill`
  froze it at 1.8.0 while upstream moved to 1.17.1.) Adding another
  third-party skill is a two-line `[[agentSkills]]` entry; restrict a
  multi-skill repo with `skills = ["name-a", "name-b"]`.
- **Local tweaks can't be silently overwritten.** The skills CLI's blanket
  `update -g -y` touches only what it installed; homegrown skills are
  chezmoi-owned, so edits land as reviewable commits.
- **App skills stay with the app.** cy's skills are operational config (org
  workflows, monitored channels), consumed only by cy — they don't belong
  in the shared pool.

## Session skills vs agent skills

- **Session skills** (interactive kimi/pi sessions, workmux/worktree
  agents): the shared `~/.agents/skills/` pool — both the homegrown and
  third-party buckets above.
- **cy's agents**: read only `~/.config/cy/skills/` — app-owned bucket.

## Cheat sheet

Add a homegrown skill:

```sh
mkdir -p dot_agents/skills/<name>
$EDITOR dot_agents/skills/<name>/SKILL.md
chezmoi apply   # deploys to ~/.agents/skills/<name>/
```

Add a third-party skill:

```toml
# .chezmoidata/agent-skills.toml
[[agentSkills]]
id = "owner/repo"
skills = ["skill-name"]   # optional; omit to install the whole repo
```

```sh
chezmoi apply   # run_onchange script installs it via the skills CLI
```
