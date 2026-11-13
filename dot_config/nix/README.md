# nix-darwin

`flake.nix.tmpl` renders per-machine user/host names into
`~/.config/nix/flake.nix`; `flake.lock` pins the nix-darwin and nixpkgs inputs.
Packages remain owned by the Homebrew Brewfile.

```sh
chezmoi apply ~/.config/nix
sudo darwin-rebuild switch --flake "$HOME/.config/nix"
```

## Menu bar

The capture from macOS Tahoe **26.7.2** on 2026-11-13 retains:

- Automatic menu-bar hiding, including in fullscreen (SketchyBar is separate).
- The blurred menu-bar background.
- Clock: AM/PM and day of week; date when space allows.
- Named visibility flags for Battery, Bluetooth, and Wi-Fi; Spotlight hidden.
- The exact current-host numeric preferences for Bluetooth, Wi-Fi, Display,
  Sound, Now Playing, and Screen Mirroring, plus Tahoe's separate Spotlight
  toggle in the user's Control Center group preferences.

The Tahoe-specific writes run only on **macOS major 26**, in the primary user's
context, using `defaults -currentHost` so the target Mac's UUID is resolved by
macOS. They write individual keys and leave other local preferences alone.
The pinned nix-darwin typed Control Center options emit older 18/24 values and
are deliberately not used for this capture. Observed 2/8 values are retained
without assuming a general cross-version visibility schema.

This is a scoped preference capture, **not a full Menu Bar / Control Center
layout restore**. Positions, Control Center grid/archive data, custom control
instances, device identifiers, service tokens, analytics, and per-app allowance
records are intentionally not copied. Custom controls and third-party app
icons must be configured locally or through their own app configuration.

Nix evaluation and generated activation commands can be checked without changing
live settings (requires chezmoi, Nix, and the cached flake inputs):

```sh
python3 -B -m unittest discover -s docs/tests -v
```

These tests check user/host scoping, selected keys, and the macOS-version guard;
they do not write preferences. The visibility/reload behavior of these private
Tahoe keys has not been runtime-tested on a second Mac. After a switch, verify the result
in System Settings → Menu Bar; log out and back in if cached UI state remains.
Re-audit the private settings before enabling them on a newer macOS major.

[Apple's macOS 26 menu-bar guide](https://support.apple.com/guide/mac-help/change-menu-bar-settings-mchlad96d366/26/mac/26)
