# Vicinae

Launcher config for [Vicinae](https://vicinae.com) (Raycast replacement).

## What chezmoi manages

| Live path                              | Source                              | Notes                                             |
| -------------------------------------- | ----------------------------------- | ------------------------------------------------- |
| `~/.config/vicinae/settings.json`      | `dot_config/vicinae/settings.json`  | Theme, global toggle, provider shortcuts/prefs    |
| `~/.local/share/vicinae/scripts/`      | `dot_local/share/vicinae/scripts/`  | Script commands (default script dir, zero config) |

**Workflow caveat:** Vicinae rewrites `settings.json` whenever you change
anything in its GUI (and strips comments/formatting when it does). After
changing settings in the GUI, adopt them back:

```bash
chezmoi re-add ~/.config/vicinae/settings.json
```

## What chezmoi does NOT manage

- **Installed extensions** (`~/.local/share/vicinae/extensions/`) — ~170 MB of
  downloaded, self-updating bundles. Vicinae has no manifest file or CLI to
  declare/reinstall them; the install set is simply the directories present.
  Reinstall from the launcher on a new machine (list below).
- **State/databases** (`vicinae.db`, `clipboard.db`, `search-history.json`,
  favicon cache, etc.) — runtime data.
- **Shortcuts & snippets** (`shortcuts/`, `snippets/`) — currently empty;
  Vicinae-managed JSON. Manage later if they get real content.

## Installed extensions (reinstall via Store command)

All from the Raycast store, installed in-app: open Vicinae → **Store** →
search the name → install.

| Extension   | Store page                                       |
| ----------- | ------------------------------------------------ |
| 1Password   | <https://www.raycast.com/khasbilegt/1password>   |
| GitHub      | <https://www.raycast.com/raycast/github>         |
| Kill Process | <https://www.raycast.com/rolandleth/kill-process> |
| Obsidian    | <https://www.raycast.com/marcjulian/obsidian>    |
| Spell       | <https://www.raycast.com/Gorzog/spell>           |

All URLs verified against the live store.
