{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      ids.gids.nixbld = 350; # NOTE: required for macOS
      services.nix-daemon.enable = true;
      programs.zsh.enable = true;
      programs.fish.enable = true;
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = false; # No longer needed with programmable keyboard
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      security.pam.enableSudoTouchIdAuth = true;

      nix.settings.experimental-features = "nix-command flakes";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

    system.defaults = {
      ".GlobalPreferences" = {
        # "com.apple.mouse.scaling" = -1.0;  # Disables mouse acceleration
        # "com.apple.mouse.scaling" = 2.0;  # Fast mouse speed
      };
      dock = {
        orientation = "right";
        autohide = true;
        mru-spaces = false;
        mineffect = "scale"; # Valid options are "genie", "scale", or "suck"
        persistent-apps = [
          "/System/Applications/Launchpad.app/"
          "/System/Applications/Calendar.app/"
          "/Applications/Inkdrop.app"
          "/Applications/WezTerm.app/"
          "/Applications/Arc.app/"
          "/Applications/Bitwarden.app/"
          "/Applications/draw.io.app/"
        ];
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        AppleShowAllFiles = true;
      };
      loginwindow = {
        LoginwindowText = "Let's Go!";
      };
      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 10;

      NSGlobalDomain = {
        NSWindowResizeTime = 0.2; # Makes window resizing faster (default is 0.2)
        NSAutomaticWindowAnimationsEnabled = true; # Disable window opening/closing animations
        NSScrollAnimationEnabled = true; # Enable smooth scrolling
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 17;
        KeyRepeat = 2;
        _HIHideMenuBar = false;
      };

      # NOTE: this is not working (Could not write domain com.apple.universalaccess; exiting)
      # universalaccess = {
      #   reduceMotion = true;
      # };
    };

    # NOTE: workaround for universalaccess.reduceMotion
    system.activationScripts.extraActivation.text = ''
      # Need to run this with sudo because universal access requires elevated privileges
      sudo defaults write com.apple.universalaccess reduceMotion -bool true
    '';

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true; # Auto update packages
          cleanup = "zap"; # Uninstall packages not defined
          upgrade = true; # Upgrade outdated packages
        };
        casks = [
          "aerospace"
          "alfred"
          "arc"
          "betterdisplay"
          "bitwarden"
          "brave-browser"
          "chromium"
          "google-chrome"
          "cleanshot"
          "contexts"
          "drawio"
          "font-commit-mono"
          "google-cloud-sdk"
          "inkdrop"
          "keycastr"
          "meetingbar"
          "mission-control-plus"
          "paintbrush"
          "slack"
          "spacelauncher"
          "stats"
          "utm"
          "wezterm"
          # "podman-desktop"
        ];
        brews = [
          "act"
          "ansible"
          "argocd"
          "atuin"
          "awscli"
          "azure-cli"
          "bash"
          "borders"
          "checkov"
          "cryptography"
          "direnv"
          "docker"
          "docker-completion"
          "docker-compose"
          "docutils"
          "dtc"
          # "espanso"
          "fd"
          "fish"
          "fisher"
          "fontconfig"
          "fzf"
          "gh"
          "git-filter-repo"
          "gnu-sed"
          "go"
          "go-task"
          "google-cloud-sdk-gke-gcloud-auth-plugin" 
          # "hcledit"
          "helm"
          "jq"
          "kind"
          "krew"
          "kubectx"
          "kubernetes-cli"
          "kustomize"
          "lazydocker"
          "lazygit"
          "lsd"
          "lua"
          "make"
          "neofetch"
          "neovim"
          "node"
          "oci-cli"
          "podman"
          "pre-commit"
          "pyenv"
          "qemu"
          "ripgrep"
          # "sketchybar"
          "sops"
          "starship"
          "stern"
          "stow"
          "telnet"
          "terraform-docs"
          "terragrunt"
          "terrascan"
          "tfenv"
          "tflint"
          "tfsec"
          "tfupdate"
          "tldr"
          "tmux"
          "tree"
          "watch"
          "yq"
          "yubikey-agent"
          "zoxide"
          "zsh-autosuggestions"
          "zsh-fast-syntax-highlighting"
          "zsh-vi-mode"
          "zstd"
          ];
        taps = [
          "FelixKratz/formulae"
          "homebrew/services"
          "minamijoyo/hcledit"
          "nikitabobko/tap"
        ];
      };
    };
  in
  {
    darwinConfigurations."LowranceWorks" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
      ];
    };

    darwinPackages = self.darwinConfigurations."LowranceWorks".pkgs;
  };
}

