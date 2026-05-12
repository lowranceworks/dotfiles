#!/bin/bash
DOTFILES_OBSIDIAN="$HOME/Projects/LowranceWorks/dotfiles/obsidian"
REGISTRY_URL="https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json"
VAULTS_DIR="$HOME/obsidian-vaults"

# Symlink dotfiles (e.g. .obsidian.vimrc) into each vault
for vault in "$VAULTS_DIR"/*/; do
  for file in "$DOTFILES_OBSIDIAN"/.*; do
    [ -f "$file" ] || continue
    filename="$(basename "$file")"
    target="$vault$filename"
    ln -sfn "$file" "$target"
    echo "linked $target"
  done
done

# Copy hotkeys into each vault's hotkeys.json (dotfiles is source of truth)
if [ -f "$DOTFILES_OBSIDIAN/hotkeys.json" ]; then
  echo ""
  for vault in "$VAULTS_DIR"/*/; do
    vault_hotkeys="$vault.obsidian/hotkeys.json"
    mkdir -p "$vault.obsidian"
    cp "$DOTFILES_OBSIDIAN/hotkeys.json" "$vault_hotkeys"
    echo "hotkeys: $(basename "$vault")"
  done
fi

# Install plugins from plugins.txt into each vault
plugin_list="$DOTFILES_OBSIDIAN/plugins.txt"
if [ ! -f "$plugin_list" ]; then
  echo "No plugins.txt found, skipping plugin install"
  exit 0
fi

echo ""
echo "Fetching Obsidian community plugin registry..."
registry=$(curl -sf "$REGISTRY_URL")
if [ -z "$registry" ]; then
  echo "ERROR: Failed to fetch plugin registry"
  exit 1
fi

while IFS= read -r plugin_id || [ -n "$plugin_id" ]; do
  plugin_id=$(echo "$plugin_id" | xargs)
  [ -z "$plugin_id" ] && continue
  [[ "$plugin_id" == \#* ]] && continue

  repo=$(echo "$registry" | python3 -c "
import sys, json
plugins = json.load(sys.stdin)
for p in plugins:
    if p['id'] == '$plugin_id':
        print(p['repo'])
        break
" 2>/dev/null)

  if [ -z "$repo" ]; then
    echo "WARNING: Plugin '$plugin_id' not found in registry, skipping"
    continue
  fi

  echo ""
  echo "Installing plugin: $plugin_id ($repo)"

  release_info=$(curl -sf "https://api.github.com/repos/$repo/releases/latest")
  if [ -z "$release_info" ]; then
    echo "  WARNING: Could not fetch latest release, skipping"
    continue
  fi

  version=$(echo "$release_info" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])" 2>/dev/null)
  echo "  Latest version: $version"

  for vault in "$VAULTS_DIR"/*/; do
    plugin_dir="$vault.obsidian/plugins/$plugin_id"
    mkdir -p "$plugin_dir"

    # Check if already at latest version
    if [ -f "$plugin_dir/manifest.json" ]; then
      current=$(python3 -c "import json; print(json.load(open('$plugin_dir/manifest.json'))['version'])" 2>/dev/null)
      if [ "$current" = "${version#v}" ]; then
        echo "  $(basename "$vault"): already at $current"
        continue
      fi
    fi

    base_url="https://github.com/$repo/releases/download/$version"
    curl -sfL -o "$plugin_dir/main.js" "$base_url/main.js"
    curl -sfL -o "$plugin_dir/manifest.json" "$base_url/manifest.json"
    curl -sfL -o "$plugin_dir/styles.css" "$base_url/styles.css" 2>/dev/null
    [ ! -s "$plugin_dir/styles.css" ] && rm -f "$plugin_dir/styles.css"

    echo "  $(basename "$vault"): installed $version"

    # Ensure plugin is in community-plugins.json (enabled list)
    cp_json="$vault.obsidian/community-plugins.json"
    if [ -f "$cp_json" ]; then
      if ! python3 -c "import json; ids=json.load(open('$cp_json')); exit(0 if '$plugin_id' in ids else 1)" 2>/dev/null; then
        python3 -c "
import json
with open('$cp_json') as f:
    ids = json.load(f)
ids.append('$plugin_id')
with open('$cp_json', 'w') as f:
    json.dump(ids, f, indent=2)
" 2>/dev/null
        echo "  $(basename "$vault"): enabled in community-plugins.json"
      fi
    else
      echo '["'"$plugin_id"'"]' > "$cp_json"
      echo "  $(basename "$vault"): created community-plugins.json"
    fi
  done
done < "$plugin_list"
