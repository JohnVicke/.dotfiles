{
  config,
  lib,
  pkgs,
  inputs,
  node_packages,
  ...
}: let
  scriptFiles = builtins.attrNames (builtins.readDir ./scripts);

  scripts =
    map (
      name: pkgs.writeShellScriptBin name (builtins.readFile ./scripts/${name})
    )
    scriptFiles;
in {
  home.username = "viktor";
  home.homeDirectory = "/home/viktor";
  xdg.configHome = "/home/viktor/.config/";
  home.stateVersion = "25.05";

  imports = [
    ./startship/starship.nix
    ./ghostty/ghostty.nix
    ./git/git.nix
    ./zsh/zsh.nix
    ./tmux/tmux.nix
    ./nvim/nvim.nix
  ];

  home.packages =
    [
      node_packages."@github/copilot"
    ]
    ++ (with pkgs; [
      nixfmt
      go
      curl
      bun
      fd
      eza
      ripgrep
      bat
      fzf
      unzip
      docker
      wl-clipboard
      fastfetch
      zen-browser
      node2nix
    ])
    ++ scripts;

  programs = {
    lazydocker = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
    gh = {
      enable = true;
      settings = {
        aliases = {
          co = "pr checkout";
        };
        git_protocol = "ssh";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = {
        global = {
          log_format = "📦: %s";
        };
      };
    };
  };

  home.file = {
    "bin/.local".source = ./scripts;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };
}
