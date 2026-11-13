# Homebrew

Packages are declared in `Brewfile`, deployed to `~/.config/homebrew/Brewfile`
by chezmoi. The first chezmoi apply runs Homebrew provisioning; after changing
an existing machine's Brewfile, apply and install explicitly:

```sh
chezmoi apply ~/.config/homebrew/Brewfile
brew bundle install --file="$HOME/.config/homebrew/Brewfile"
```

## Login services

SketchyBar and JankyBorders (`borders`) use `start_service: true` in the
Brewfile. Homebrew starts them immediately and registers them to start at
login. Run Homebrew as your normal user, **not with sudo**.

Homebrew owns both services; AeroSpace only sends workspace-change events to
SketchyBar and must not launch another instance of either service.

To enable just these services on an existing machine without installing the
entire Brewfile:

```sh
chezmoi apply ~/.config/aerospace ~/.config/sketchybar ~/.config/borders
brew install FelixKratz/formulae/sketchybar FelixKratz/formulae/borders
brew services start sketchybar
brew services start borders
```

After editing their configurations, apply and restart:

```sh
chezmoi apply ~/.config/sketchybar ~/.config/borders
brew services restart sketchybar
brew services restart borders
```

Check their status with `brew services list`.
