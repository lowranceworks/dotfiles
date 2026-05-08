#!/bin/bash
DOTFILES_OBSIDIAN="$HOME/Projects/LowranceWorks/dotfiles/obsidian"

for vault in "$HOME/obsidian-vaults/"/*/; do
  for file in "$DOTFILES_OBSIDIAN"/.*; do
    [ -f "$file" ] || continue
    filename="$(basename "$file")"
    target="$vault$filename"
    ln -sfn "$file" "$target"
    echo "linked $target -> $file"
  done
done
