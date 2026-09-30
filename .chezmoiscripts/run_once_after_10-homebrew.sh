#!/usr/bin/env bash
# shellcheck shell=bash

# Install Homebrew and packages

if [ -n "${CI:-}" ]; then
    echo "Skipping due to \$CI"
    exit
fi

export PATH="/opt/homebrew/bin:/usr/local/bin${PATH+:$PATH}"
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing Homebrew packages..."
if ! brew bundle check --file="$HOME/.config/homebrew/Brewfile" &>/dev/null; then
    brew bundle install --file="$HOME/.config/homebrew/Brewfile" ||
        echo "WARNING: brew bundle had failures (see above); continuing anyway"
fi
