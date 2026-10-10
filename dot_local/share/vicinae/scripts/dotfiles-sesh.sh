#!/bin/bash

# Required parameters:
# @vicinae.schemaVersion 1
# @vicinae.title dotfiles
# @vicinae.mode silent

# Optional parameters:
# @vicinae.icon 🤖

# Documentation:
# @vicinae.description Open dotfiles
# @vicinae.author joshmedeski
# @vicinae.authorURL https://github.com/joshmedeski

~/go/bin/sesh connect --switch "dotfiles"
open -a "Wezterm"
