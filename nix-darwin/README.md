# nix-darwin

## Managing configuration with Nix

### Installation

Use the official Determinate Systems Nix installer:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

This installer is preferred for **macOS** because it:

- Properly handles macOS security features like System Integrity Protection (SIP)
- Sets up the nix daemon correctly
- Includes automatic updates for the nix daemon
- Handles both Intel and Apple Silicon Macs properly
- Provides an easy uninstall option if needed
- Maintains compatibility with newer macOS versions

### Applying the Nix configuration

#### Install homebrew

[homebrew](https://brew.sh/) is required to apply this configuration, make sure that you have this installed.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Clone dotfiles

```sh
mkdir -p ~/projects/lowranceworks/
git clone https://github.com/lowranceworks/dotfiles.git ~/projects/lowranceworks/dotfiles
```

#### Apply configuration for the first time

```sh
cd ~/projects/lowranceworks/dotfiles/nix-darwin/
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .#LowranceWorks
```

#### Rebuild the configuration

For any changes made after applying the configuration for the first time:

```sh
darwin-rebuild switch --flake .#LowranceWorks
```

## Troubleshooting

### SSL certificates

If you get SSL certificate errors during the nix-darwin setup, you may need to run the certificate setup commands:

```sh
sudo mkdir -p /etc/ssl/certs
sudo security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > /tmp/ca-certificates.crt
sudo mv /tmp/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
sudo chmod 644 /etc/ssl/certs/ca-certificates.crt
```
