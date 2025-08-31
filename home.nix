{ config, pkgs, ... }:

{
  home.username = "viktor";
  home.homeDirectory = "/home/viktor";
  xdg.configHome = "/home/viktor/.config/";
  home.stateVersion = "25.05"; 

  imports = [ ./git/flake.nix ];

  home.packages = with pkgs; [
    curl
    fd
    eza
    ripgrep
    bat
    fzf
    direnv
    unzip
  ];

  programs = {
    home-manager = {enable = true; };
    neovim = { enable = true; };
    tmux = { enable = true; };
    gh = {
      enable = true;
      settings = {
        aliases = { co = "pr checkout"; };
        git_protocol = "ssh";
      };
    };
  };

  home.file = {
    ".config/nvim".source = ./nvim;
    ".zshrc".source = ./zsh/.zshrc;
    ".tmux.conf".source = ./tmux/.tmux.conf;
    "bin/.local".source = ./bin/.local;
    ".config/starship.toml".source = ./starship/config.toml;
  };

  home.sessionVariables = {
  };

}
