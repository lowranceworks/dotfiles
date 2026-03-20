#!/bin/bash

# Create symlink from dotfiles inkdrop config to ~/Library/Application Support/inkdrop
mkdir -p ~/Library/Application\ Support/inkdrop
ln -sf ~/projects/lowranceworks/dotfiles/inkdrop/.config/inkdrop/keymap.json ~/Library/Application\ Support/inkdrop/keymap.json
echo "Inkdrop config symlinked!"

# Install Plugins
~/projects/lowranceworks/dotfiles/inkdrop/.config/inkdrop/ipm-install.sh
