#!/usr/bin/env bash
set -euo pipefail

# Existing Macs have a saved default, so modify_settings.json's seeds cannot
# replace it. Run once per machine; later Ctrl+S choices remain Pi-owned.
settings="$HOME/.pi/agent/settings.json"
if [[ ! -f "$settings" ]]; then
    echo "Pi settings not found: $settings" >&2
    exit 1
fi

temporary=$(mktemp "${settings}.XXXXXX")
trap 'rm -f "$temporary"' EXIT
cp -p "$settings" "$temporary"
jq '.defaultProvider = "ollama-cloud" | .defaultModel = "glm-5.3:cloud"' "$settings" > "$temporary"
mv "$temporary" "$settings"
