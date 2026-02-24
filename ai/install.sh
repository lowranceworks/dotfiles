#!/bin/bash
DOTFILES_AI="$HOME/Projects/LowranceWorks/dotfiles/ai"

link() {
  local target="$HOME/$1"
  mkdir -p "$(dirname "$target")"
  ln -sfn "$DOTFILES_AI/$2" "$target"
  echo "linked $target -> $DOTFILES_AI/$2"
}

# AI tools
link ".claude/skills" "skills"
link ".gemini/skills" "skills"
link ".codex/skills" "skills"

# Add Skills to all Obsidian vaults
for vault in "$HOME/obsidian-vaults/"/*/; do
  for skill in "$DOTFILES_AI/skills/"/*/; do
    skill_name="$(basename "$skill")"
    target="$vault/99 System/Skills/$skill_name/SKILL.md"
    mkdir -p "$(dirname "$target")"
    ln -sfn "$skill/SKILL.md" "$target"
    echo "linked $target -> $skill/SKILL.md"
  done
done

# Add Agents to all Obsidian vaults
for agent in "$DOTFILES_AI/agents/"/*/; do
  agent_name="$(basename "$agent")"
  for vault in "$HOME/obsidian-vaults/"/*/; do
    target="$vault/99 System/Agents/$agent_name"
    mkdir -p "$(dirname "$target")"
    ln -sfn "$agent" "$target"
    echo "linked $target -> $agent"
  done
done

# Add Subagents to all Obsidian vaults
for subagent in "$DOTFILES_AI/subagents/"*.md; do
  subagent_name="$(basename "$subagent")"
  for vault in "$HOME/obsidian-vaults/"/*/; do
    target="$vault/99 System/Subagents/$subagent_name"
    mkdir -p "$(dirname "$target")"
    ln -sfn "$subagent" "$target"
    echo "linked $target -> $subagent"
  done
done
