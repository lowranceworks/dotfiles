# nix-darwin

```sh
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .#"LowranceWorks"
```

## Troubleshoting

### `darwin-rebuild switch` fails with `error: attribute 'darwinConfigurations' missing`

```stdout
libc++abi: terminating due to uncaught exception of type nix::Error: error: not an absolute path: '~/projects/lowranceworks/dotfiles/nix'
Error: nu::shell::terminated_by_signal

  × External command was terminated by a signal
   ╭─[entry #13:1:1]
 1 │ nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .#"LowranceWorks" -v
   · ─┬─
   ·  ╰── terminated by SIGABRT (6)
   ╰────

```

To fix this:

Either restart your shell session to pick up the new configuration or temporarily override it in your current session:

```sh
$env.NIX_CONF_DIR = "/Users/josh/projects/lowranceworks/dotfiles/nix"
```
