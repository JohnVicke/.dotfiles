{ config, lib, pkgs, inputs, node_packages, ... }:

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
		./nvim/nvim.nix
  ];

  home.packages = ([
		node_packages."@github/copilot"
	]) ++ (with pkgs; [
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
    nodejs
    yarn
		fastfetch
		zen-browser
		node2nix
  ]) ++ scripts;

  programs = {
    lazydocker = { enable = true; };
    lazygit = { enable = true; };
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = { 
        font-family = "MonaspiceAr Nerd Font";
        theme = "vague";
      };
      package = pkgs.writeShellScriptBin "ghostty" ''
        exec ${pkgs.nixGL.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
        '';
      themes = {
        vague = {
          palette = [
              "0=#252530"
              "1=#d8647e"
              "2=#7fa563"
              "3=#f3be7c"
              "4=#6e94b2"
              "5=#bb9dbd"
              "6=#aeaed1"
              "7=#cdcdcd"
              "8=#606079"
              "9=#e08398"
              "10=#99b782"
              "11=#f5cb96"
              "12=#8ba9c1"
              "13=#c9b1ca"
              "14=#bebeda"
              "15=#d7d7d7"
          ];
          background = "#141415";
          foreground = "#cdcdcd";
          cursor-color = "#cdcdcd";
          selection-background = "#252530";
          selection-foreground = "#cdcdcd";
          };
      };
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
            "$line_break"
            "$character"
        ];
        fill = { symbol = " "; };
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
    "bin/.local".source = ./scripts;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };
}
