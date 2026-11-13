# Vorssaint

Installed by the `vorssaint` Homebrew cask (Apple Silicon, macOS 14+). The
read-only startup configuration requires **Vorssaint 3.4.4 or later**.

`settings.plist` deploys to `~/.config/vorssaint/settings.plist`. Vorssaint
reads this version-1 plist envelope on each normal launch and overlays the
listed settings onto its local preferences. Omitted settings stay local;
removing a declaration does not reset its previously applied value.

## Captured preferences

Captured from the configured Mac's 3.4.4 settings on 2026-11-13. Only explicitly
persisted, exportable preferences are included, not the full set of registered
defaults. All feature-availability switches are preserved, including disabled
features. Enabled features are keep-awake, auto-quit, Dock click/preview, app
switcher, volume mixer, and CPU/GPU/memory/disk/network/power monitoring.
Login launch is requested, and the existing icon, panel, and monitor choices
are retained.

Onboarding/version markers, migration state, permissions, window geometry,
clipboard/shelf/scratchpad content, and snippet data are not managed. macOS
permissions and login-item approval remain per-machine setup. First-run
onboarding may still appear, but the declared feature choices are preserved.

## Apply on another Mac

```sh
chezmoi apply ~/.config/homebrew/Brewfile ~/.config/vorssaint
brew install --cask vorssaint
open -a Vorssaint
```

If Vorssaint is already running, quit it before reopening to load the file.
The default `~/.config` path works for GUI launches without environment setup.
If using a custom `XDG_CONFIG_HOME`, it must also be set in the GUI app's
launch environment.

## Refresh the capture

Configure through the UI, then export to a **separate review file**:

```sh
/Applications/Vorssaint.app/Contents/MacOS/Vorssaint \
  --export-settings "$HOME/Downloads/vorssaint-settings.plist"
```

The export contains every exportable registered default, not just changed
settings, and may include private text snippets. Review it before copying
selected entries into this file; keep `vorssaintBackupVersion` and `settings`.
Do not overwrite this curated file with an unreviewed full export.

Do **not** use `--import-settings` to apply a partial configuration: explicit
import is a full restore and resets missing exportable preferences. Use the
startup overlay instead. Leave `~/Library/Preferences/com.vorssaint.utils.plist`
to the app rather than managing or symlinking its live preference store.

[Official dotfiles guide](https://github.com/vorssaint/vorssaint-utils/blob/v3.4.4/docs/TROUBLESHOOTING.md#keeping-settings-in-your-dotfiles)
