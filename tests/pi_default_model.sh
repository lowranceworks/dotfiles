#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/source/dot_pi/agent" "$tmp/home/.pi/agent"
cp "$repo/dot_pi/agent/modify_settings.json" "$tmp/source/dot_pi/agent/modify_settings.json"
settings="$tmp/home/.pi/agent/settings.json"

render_settings() {
    chezmoi -c /dev/null --config-format=toml -S "$tmp/source" -D "$tmp/home" \
        --override-data "{\"mlb\":$1,\"piPackages\":[]}" cat "$settings"
}

# A fresh Mac of either profile starts with Ollama.
for mlb in true false; do
    rm -f "$settings"
    render_settings "$mlb" | jq -e '.defaultProvider == "ollama-cloud" and .defaultModel == "glm-5.3:cloud"' >/dev/null
done

# An existing Mac's previous default changes once, without dropping Pi-owned state.
printf '%s\n' '{"defaultProvider":"openrouter","defaultModel":"moonshotai/kimi-k3","theme":"custom","packages":["npm:pi-exa"]}' > "$settings"
migration="$repo/.chezmoiscripts/run_once_after_14-seed-pi-ollama-model.sh"
if [[ ! -f "$migration" ]]; then
    echo 'Expected a one-time Pi default-model migration' >&2
    exit 1
fi
HOME="$tmp/home" bash "$migration"
jq -e '.defaultProvider == "ollama-cloud" and .defaultModel == "glm-5.3:cloud" and .theme == "custom" and .packages == ["npm:pi-exa"]' "$settings" >/dev/null

# Future applies leave a later Ctrl+S choice untouched.
jq '.defaultProvider = "github-copilot" | .defaultModel = "gpt-5.4"' "$settings" > "$tmp/next-settings.json"
mv "$tmp/next-settings.json" "$settings"
render_settings true | jq -e '.defaultProvider == "github-copilot" and .defaultModel == "gpt-5.4"' >/dev/null

# Verify chezmoi's real run_once behavior: a later apply must not rerun migration.
mkdir -p "$tmp/source/.chezmoiscripts"
cp -p "$migration" "$tmp/source/.chezmoiscripts/"
printf '%s\n' '{"defaultProvider":"openrouter","defaultModel":"moonshotai/kimi-k3"}' > "$settings"
apply_sandbox() {
    HOME="$tmp/home" chezmoi -c /dev/null --config-format=toml -S "$tmp/source" -D "$tmp/home" \
        --cache "$tmp/cache" --persistent-state "$tmp/state" \
        --override-data '{"mlb":true,"piPackages":[]}' apply --force
}
apply_sandbox
jq -e '.defaultProvider == "ollama-cloud" and .defaultModel == "glm-5.3:cloud"' "$settings" >/dev/null
jq '.defaultProvider = "github-copilot" | .defaultModel = "gpt-5.4"' "$settings" > "$tmp/next-settings.json"
mv "$tmp/next-settings.json" "$settings"
apply_sandbox
jq -e '.defaultProvider == "github-copilot" and .defaultModel == "gpt-5.4"' "$settings" >/dev/null
printf '%s\n' 'Pi default-model settings passed'
