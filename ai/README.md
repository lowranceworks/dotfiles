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

Run once to wire everything up:

```sh
./install.sh
```

---

```STDOUT
linked /Users/josh/.claude/skills -> /Users/josh/Projects/LowranceWorks/dotfiles/ai/skills
linked /Users/josh/.gemini/skills -> /Users/josh/Projects/LowranceWorks/dotfiles/ai/skills
linked /Users/josh/.codex/skills -> /Users/josh/Projects/LowranceWorks/dotfiles/ai/skills
```

> **Note:** Symlink the `ai/skills` directory *as* the target path — don't symlink it *into* an existing directory or you'll get a nested `skills/skills/` path.

## Adding a New Skill

```sh
mkdir skills/my-new-skill
touch skills/my-new-skill/SKILL.md
```

No re-linking needed — existing symlinks pick it up automatically.

## Adding a New Tool

```sh
mkdir -p ~/.newtool
ln -s ~/Projects/LowranceWorks/dotfiles/ai/skills ~/.newtool/skills
```
```
