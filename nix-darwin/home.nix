{ config, pkgs, dotfiles, ... }:
{
  # TODO: find a way to do this without hardcoding the user
  home.username = "josh";
  home.homeDirectory = "/Users/josh";
  home.stateVersion = "23.05";

  home.packages = [
    # Packages you want to install
    # pkgs.fish
  ];

  home.sessionVariables = {
    PATH = "$PATH:/run/current-system/sw/bin:$HOME/.nix-profile/bin";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };

  # TODO: add programs config for each one
  #
  # programs.fish.enable = true;
  # programs.starship.enable = true;
  # programs.tmux.enable = true;
}
