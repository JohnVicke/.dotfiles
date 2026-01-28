{
  config,
  lib,
  pkgs,
  inputs,
  node_packages,
  ...
}:
let
  scriptFiles = builtins.attrNames (builtins.readDir ./scripts);

  scripts = map (
    name: pkgs.writeShellScriptBin name (builtins.readFile ./scripts/${name})
  ) scriptFiles;
  opencode-bun = pkgs.callPackage ./opencode-bun/opencode-bun.nix { };
in
{
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

  home.packages = [
    node_packages."@github/copilot"
  ]
  ++ (with pkgs; [
    kooha
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
    wl-clipboard
    fastfetch
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
    "bin/.local".source = ./scripts;
    ".config/opencode/opencode.json".source = ./opencode-bun/opencode.json;
    ".config/opencode/AGENTS.md".source = ./opencode-bun/AGENTS.md;
    ".config/opencode/agent".source = ./opencode-bun/agent;
    ".config/opencode/skill".source = ./opencode-bun/skill;
    ".config/opencode/command".source = ./opencode-bun/command;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };

  xdg.mimeApps =
    let
      zenDesktop = config.programs.zen-browser.package.meta.desktopFileName;
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = zenDesktop;
          })
          [
            "text/html"
            "application/xhtml+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unknown"
            "x-scheme-handler/chrome"
          ]
      );
    in
    {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };

  xdg.configFile."mimeapps.list".force = true;
}
