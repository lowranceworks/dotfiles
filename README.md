# Joshua Lowrance's Dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/): XDG-compliant layout under `dot_config/`, role-based templating (`mlb` / `personal`), and provisioning via `.chezmoiscripts/`.

## Stack

- **Terminal**: [Wezterm](https://wezfurlong.org/wezterm)
- **Font**: [Monaspace](https://monaspace.githubnext.com/)
- **Color scheme**: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
- **Shell**: [Fish](https://fishshell.com)
- **Prompt**: [Starship](https://starship.rs)
- **Multiplexer**: [tmux](https://github.com/tmux/tmux/wiki)
  - Session manager: [sesh](https://github.com/joshmedeski/sesh) / [sessionx](https://github.com/omerxx/tmux-sessionx)
- **Editor**: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- **Git TUI**: [lazygit](https://github.com/jesseduffield/lazygit)
- **System Info**: [Neofetch](https://github.com/dylanaraps/neofetch)
- **Window Manager**: [Aerospace](https://github.com/nikitabobko/AeroSpace)
- **Menu Bar**: [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- **Hotkeys**: [skhd](https://github.com/koekeishiya/skhd)
- **Automation**: [Hammerspoon](https://www.hammerspoon.org/)
- **Launcher**: [Vicinae](https://vicinae.com)
- **Browser Extensions**: [Vimium](https://vimium.github.io/)
- **Package Managers**:
  - macOS: [Homebrew](https://brew.sh)
  - Nix: [Nix](https://nixos.org/) / [nix-darwin](https://github.com/LnL7/nix-darwin)
- **Dotfile Manager**: [chezmoi](https://www.chezmoi.io/)

## Installation

If you already have `chezmoi`:

```bash
chezmoi init --apply lowranceworks
```

Otherwise:

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply lowranceworks
```

`chezmoi init` prompts for two independent **roles** — `mlb` and `personal` — which gate machine-specific git identity and credentials. A machine can carry both.

After applying, `.chezmoiscripts/` installs Homebrew packages (`brew bundle`), copies AI skills/agents to tool config dirs and Obsidian vaults, and syncs Obsidian community plugins.

## Daily workflow

chezmoi **copies** files rather than symlinking. Edit files in this repo, then:

```bash
chezmoi apply          # deploy changes
chezmoi diff           # preview what would change
chezmoi update         # pull + apply
```

or edit the live file and adopt it back with `chezmoi edit` / `chezmoi re-add`.

## Structure

- `dot_config/` — everything under `~/.config/` (fish, nvim, tmux, wezterm, git, ...)
- `dot_zshenv`, `dot_bashrc`, `dot_bash_profile` — home-root bootstraps (zsh `ZDOTDIR`, bash sourcing)
- `private_dot_ssh/` — `~/.ssh/` config and public keys (private permissions; no private keys)
- `dot_agents/skills/` — agent skills deployed to `~/.agents/skills/`
- `dot_pi/` — pi-coding-agent config (`~/.pi/agent/`): `modify_settings.json` merges into pi's live `settings.json` (role-seeded provider/model, catppuccin theme, packages unioned from `.chezmoidata/pi-packages.toml`, installed by `run_onchange_after_13-install-pi-packages.sh.tmpl`), subagent extension symlinked from the Homebrew formula, review/research subagents, catppuccin themes
- `.chezmoi.toml.tmpl` — config template; prompts for `mlb` / `personal` roles
- `.chezmoiignore` — paths not deployed (docs, scripts-only dirs, runtime state)
- `.chezmoiscripts/` — provisioning scripts (`run_once_`, `run_onchange_`)
- `apps/` — source content not deployed directly (obsidian vault sync, vimium options; used by scripts or applied by other means)

Runtime state (e.g. `fish_variables`, `k9s/aliases.yaml`, `tmux/plugins/`) is intentionally not managed — the tools own those files after first deploy.
