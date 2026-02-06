# Shared/common configuration for all platforms
{
  config,
  lib,
  pkgs,
  node_packages,
  ...
}: let
  scriptFiles = builtins.attrNames (builtins.readDir ../scripts);

  scripts =
    map (
      name: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${name})
    )
    scriptFiles;
in {
  imports = [
    ../startship/starship.nix
    ../ghostty/ghostty.nix
    ../git/git.nix
    ../zsh/zsh.nix
    ../tmux/tmux.nix
    ../nvim/nvim.nix
  ];

  # Common packages for all platforms
  home.packages =
    (with pkgs; [
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
      uv
      docker
      fastfetch
      hyperfine
      node2nix
      just
      apacheHttpd
      yazi
    ])
    ++ scripts;

  programs = {
    zen-browser = {
      enable = true;
    };
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
    "bin/.local".source = ../scripts;
    ".config/opencode/opencode.json".source = ../opencode-bun/opencode.json;
    ".config/opencode/AGENTS.md".source = ../opencode-bun/AGENTS.md;
    ".config/opencode/agent".source = ../opencode-bun/agent;
    ".config/opencode/skill".source = ../opencode-bun/skill;
    ".config/opencode/command".source = ../opencode-bun/command;
  };
}
