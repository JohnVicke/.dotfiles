{ config, lib, pkgs, ... }:

let
  scriptFiles = builtins.attrNames (builtins.readDir ./scripts);

  scripts = map (name:
    pkgs.writeShellScriptBin name (builtins.readFile ./scripts/${name})
  ) scriptFiles;
in {
  home.username = "viktor";
  home.homeDirectory = "/home/viktor";
  xdg.configHome = "/home/viktor/.config/";
  home.stateVersion = "25.05"; 

  imports = [ 
    ./git/git.nix 
    ./zsh/zsh.nix
    ./tmux/tmux.nix
    # ./nvim2/nvim.nix
  ];

  home.packages = with pkgs; [
    curl
    fd
    eza
    ripgrep
    bat
    fzf
    unzip
    docker
    wl-clipboard
  ] ++ scripts;

  programs = {
    lazygit = { enable = true; };
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = { 
        font-family = "MonaspiceAr Nerd Font";
        theme = "rose-pine";
      };
      package = pkgs.writeShellScriptBin "ghostty" ''
        exec ${pkgs.nixGL.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
        '';
    };
    home-manager = {enable = true; };
    neovim = { 
      enable = true; 
      withNodeJs = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
            "$directory"
            "$git_branch$git_state"
            "$fill"
            "$gcloud"
            "$python$go$nodejs$lua"
            "$line_break"
            "$character"
        ];
        character = {
          success_symbol = "[\\[I\\] ➜](purple)";
          error_symbol = "[\\[I\\] ➜](red)";
          vicmd_symbol = "[\\[N\\] ➜](green)";
        };
        git_state = { 
          format = "\\([$state( $progress_current/$progress_total)]($style)\\)";
          style = "bright-black";
        };
        gcloud = {
          format = "\\[[$symbol$project]($style)\\]";
          symbol = "";
        };
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
    gh = {
      enable = true;
      settings = {
        aliases = { co = "pr checkout"; };
        git_protocol = "ssh";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.file = {
    ".config/nvim".source = ./nvim;
    "bin/.local".source = ./scripts;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };
}
