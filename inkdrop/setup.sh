#!/usr/bin/env bash
# shellcheck shell=bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlink from dotfiles inkdrop config to ~/Library/Application Support/inkdrop
mkdir -p ~/Library/Application\ Support/inkdrop
ln -sf "$SCRIPT_DIR/.config/inkdrop/keymap.json" ~/Library/Application\ Support/inkdrop/keymap.json
echo "Inkdrop config symlinked!"

# Install Plugins
"$SCRIPT_DIR/.config/inkdrop/ipm-install.sh"
