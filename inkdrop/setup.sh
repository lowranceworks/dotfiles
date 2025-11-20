#!/bin/bash

# Create symlink from dotfiles inkdrop config to ~/Library/Application Support/Inkdrop
mkdir -p ~/Library/Application\ Support/Inkdrop
ln -sf ~/projects/lowranceworks/dotfiles/inkdrop/.config/inkdrop/keymap.json ~/Library/Application\ Support/Inkdrop/keymap.json

echo "Inkdrop config symlinked!"
