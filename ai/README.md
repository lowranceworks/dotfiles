# AI

Centralized AI configuration — skills, agents, and subagents shared across tools.

## Structure

```
ai/
├── agents/        # Top-level AI assistant context files (CLAUDE.md, GEMINI.md)
├── skills/        # Reusable skill workflows, one dir per skill
└── subagents/     # Engineering persona agents
```

## Install

Installed automatically by chezmoi via
`.chezmoiscripts/run_onchange_after_15-ai-skills.sh.tmpl`, which copies
`ai/skills`, `ai/agents`, and `ai/subagents` into `~/.claude/skills`,
`~/.gemini/skills`, `~/.codex/skills`, and every vault under
`~/obsidian-vaults/`. Re-runs on `chezmoi apply` whenever anything under
`ai/` changes.

---

```STDOUT
copied <sourceDir>/ai/skills -> /Users/josh/.claude/skills
copied <sourceDir>/ai/skills -> /Users/josh/.gemini/skills
copied <sourceDir>/ai/skills -> /Users/josh/.codex/skills
```

## Adding a New Skill

```sh
mkdir skills/my-new-skill
touch skills/my-new-skill/SKILL.md
```

No manual step needed — the run_onchange script picks it up on the next `chezmoi apply`.

## Adding a New Tool

Copy (don't symlink) the skills into the tool's config dir by adding another
`copy` line to `.chezmoiscripts/run_onchange_after_15-ai-skills.sh.tmpl`:

```sh
copy ".newtool/skills" "skills"
```
```
