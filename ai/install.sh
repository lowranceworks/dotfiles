#!/bin/bash
DOTFILES_AI="$HOME/Projects/LowranceWorks/dotfiles/ai"

link() {
  local target="$HOME/$1"
  mkdir -p "$(dirname "$target")"
  ln -sfn "$DOTFILES_AI/$2" "$target"
  echo "linked $target -> $DOTFILES_AI/$2"
}

link ".claude/skills" "skills"
link ".gemini/skills" "skills"
link ".codex/skills" "skills"
