{ config, pkgs, dotfiles, ... }:
{
  # TODO: find a way to do this without hardcoding the user
  home.username = "joshua";
  home.homeDirectory = "/Users/joshua";
  home.stateVersion = "23.05";

  home.packages = [
    # Add any packages you want to install
  ];

  home.file = {
    ".skhdrc".source = "${dotfiles}/skhd/.skhdrc";
    ".yabairc".source = "${dotfiles}/yabai/.yabairc";
    ".config/starship.toml".source = "${dotfiles}/starship/starship.toml";
    ".config/fish".source = "${dotfiles}/fish";
    ".config/wezterm".source = "${dotfiles}/wezterm";
    ".config/lazygit".source = "${dotfiles}/lazygit";
    ".config/neofetch".source = "${dotfiles}/neofetch";
    ".config/nvim".source = "${dotfiles}/nvim";
    ".config/nix".source = "${dotfiles}/nix";
    ".config/nix-darwin".source = "${dotfiles}/nix-darwin";
    ".config/tmux".source = "${dotfiles}/tmux";
  };

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
