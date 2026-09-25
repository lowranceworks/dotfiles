#!/bin/bash
DOTFILES_AI="$HOME/Projects/LowranceWorks/dotfiles/ai"

copy() {
  local target="$HOME/$1"
  mkdir -p "$(dirname "$target")"
  rm -rf "$target"
  cp -R "$DOTFILES_AI/$2" "$target"
  echo "copied $DOTFILES_AI/$2 -> $target"
}

# AI tools
copy ".claude/skills" "skills"
copy ".gemini/skills" "skills"
copy ".codex/skills" "skills"

# Add Skills to all Obsidian vaults
for vault in "$HOME/obsidian-vaults/"/*/; do
  for skill in "$DOTFILES_AI/skills/"/*/; do
    skill_name="$(basename "$skill")"
    target="$vault/99 System/Skills/$skill_name/SKILL.md"
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp "$skill/SKILL.md" "$target"
    echo "copied $skill/SKILL.md -> $target"
  done
done

# Add Agents to all Obsidian vaults
for agent in "$DOTFILES_AI/agents/"/*/; do
  agent_name="$(basename "$agent")"
  for vault in "$HOME/obsidian-vaults/"/*/; do
    target="$vault/99 System/Agents/$agent_name"
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp -R "$agent" "$target"
    echo "copied $agent -> $target"
  done
done

# Add Subagents to all Obsidian vaults
for subagent in "$DOTFILES_AI/subagents/"*.md; do
  subagent_name="$(basename "$subagent")"
  for vault in "$HOME/obsidian-vaults/"/*/; do
    target="$vault/99 System/Subagents/$subagent_name"
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp "$subagent" "$target"
    echo "copied $subagent -> $target"
  done
done
