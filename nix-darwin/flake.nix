 {
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:/Users/josh/Projects/lowranceworks/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, dotfiles }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.vim
        pkgs.direnv
        # pkgs.age
        # pkgs.sshs
        # pkgs.atac
        # pkgs.termshark
        # pkgs.portal
        # pkgs.glow
      ];
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      programs.fish.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      security.pam.enableSudoTouchIdAuth = true;

      users.users.josh.home = "/Users/josh";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "Joshua Lowrance";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };

      homebrew.enable = true;
      homebrew.casks = [
        "google-chrome"
        "alfred"
        "bitwarden"
        "brave-browser"
        "choosy"
        "chromium"
        "cleanshot"
        "contexts"
        "drawio"
        "fork"
        "google-chrome"
        "google-cloud-sdk"
        "inkdrop"
        "iterm2"
        "karabiner-elements"
        "keycastr"
        "logitech-options"
        "meetingbar"
        "microsoft-auto-update"
        "microsoft-excel"
        "microsoft-outlook"
        "microsoft-teams"
        "mission-control-plus"
        "paintbrush"
        "podman-desktop"
        "rectangle-pro"
        "sensiblesidebuttons"
        "sf-symbols"
        "slack"
        "spacelauncher"
        "stats"
        "utm"
        "wezterm"
        "homebrew/cask-fonts/font-fontawesome"
        "homebrew/cask-fonts/font-hack-nerd-font"
      ];
      homebrew.brews = [
        "imagemagick"
        "act"
        "ansible"
        "aom"
        "apr"
        "apr-util"
        "argocd"
        "argon2"
        "aspell"
        "autoconf"
        "awscli"
        "azure-cli"
        "bash"
        "bat"
        "bdw-gc"
        "berkeley-db"
        "berkeley-db@5"
        "bind"
        "bottom"
        "brotli"
        "c-ares"
        "ca-certificates"
        "cairo"
        "capstone"
        "cffi"
        "checkov"
        "cryptography"
        "curl"
        "direnv"
        "docker"
        "docker-completion"
        "docker-compose"
        "docutils"
        "dtc"
        "fd"
        "fish"
        "fisher"
        "fontconfig"
        "freetds"
        "freetype"
        "fzf"
        "gcc"
        "gd"
        "gdbm"
        "gettext"
        "gh"
        "ghostscript"
        "giflib"
        "git"
        "git-delta"
        "git-filter-repo"
        "glib"
        "gmp"
        "gnu-sed"
        "gnupg"
        "gnutls"
        "go"
        "go-task"
        "graphite2"
        "grep"
        "groff"
        "guile"
        "harfbuzz"
        "helm"
        "highway"
        "icu4c"
        "ifstat"
        "imap-uw"
        "imath"
        "isl"
        "jasper"
        "jbig2dec"
        "jpeg-turbo"
        "jpeg-xl"
        "jq"
        "json-c"
        "kind"
        "krb5"
        "krew"
        "kubectx"
        "kubernetes-cli"
        "kustomize"
        "lazydocker"
        "lazygit"
        "lf"
        "libassuan"
        "libavif"
        "libcbor"
        "libevent"
        "libfido2"
        "libgcrypt"
        "libgit2"
        "libgit2@1.6"
        "libgpg-error"
        "libidn"
        "libidn2"
        "libksba"
        "liblinear"
        "libmpc"
        "libnghttp2"
        "libpaper"
        "libpng"
        "libpq"
        "libsecret"
        "libslirp"
        "libsodium"
        "libssh"
        "libssh2"
        "libtasn1"
        "libtermkey"
        "libtiff"
        "libtool"
        "libunistring"
        "libusb"
        "libuv"
        "libvmaf"
        "libvterm"
        "libx11"
        "libxau"
        "libxcb"
        "libxdmcp"
        "libxext"
        "libxrender"
        "libyaml"
        "libzip"
        "little-cms2"
        "llvm"
        "lsd"
        "lua"
        "lua@5.3"
        "luajit"
        "luv"
        "lz4"
        "lzo"
        "m4"
        "mackup"
        "make"
        "maven"
        "mpdecimal"
        "mpfr"
        "msgpack"
        "ncurses"
        "neofetch"
        "neovim"
        "netpbm"
        "nettle"
        "nmap"
        "node"
        "npth"
        "nvm"
        "oniguruma"
        "openblas"
        "openexr"
        "openjdk"
        "openjdk@11"
        "openjpeg"
        "openldap"
        "openssl@1.1"
        "openssl@3"
        "p11-kit"
        "pcre"
        "pcre2"
        "perl"
        "pgcli"
        "php"
        "pinentry"
        "pixman"
        "pkg-config"
        "podman"
        "pre-commit"
        "psutils"
        "pycparser"
        "pyenv"
        "qemu"
        "readline"
        "ripgrep"
        "rtmpdump"
        "ruby"
        "rust"
        "screenresolution"
        "six"
        "snappy"
        "sops"
        "sqlite"
        "sqlparse"
        "starship"
        "stern"
        "telnet"
        "terraform-docs"
        "terragrunt"
        "terrascan"
        "tfenv"
        "tflint"
        "tfsec"
        "tfupdate"
        "tidy-html5"
        "tldr"
        "tmux"
        "tree"
        "tree-sitter"
        "uchardet"
        "unbound"
        "unibilium"
        "unixodbc"
        "utf8proc"
        "vde"
        "wakatime-cli"
        "watch"
        "webp"
        "wget"
        "xorgproto"
        "xz"
        "yq"
        "yubikey-agent"
        "z3"
        "zf"
        "zoxide"
        "zsh-autosuggestions"
        "zsh-fast-syntax-highlighting"
        "zsh-vi-mode"
        "zstd"
        "federico-terzi/espanso/espanso"
        "koekeishiya/formulae/skhd"
        "koekeishiya/formulae/yabai"
        "minamijoyo/hcledit/hcledit"
      ];
    };
  in
  {
    darwinConfigurations."Joshs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.josh = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit dotfiles; };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."Joshs-MacBook-Pro".pkgs;
  };
}
