{
  config,
  lib,
  pkgs,
  inputs,
  node_packages,
  isLinux,
  system,
  ...
}: let
  # Get all script files and filter platform-specific ones
  allScriptFiles = builtins.attrNames (builtins.readDir ./scripts);

  # Platform-specific suffixes
  linuxSuffix = "-linux";
  darwinSuffix = "-darwin";

  # Filter: include scripts without platform suffix, or matching current platform
  scriptFiles =
    builtins.filter (
      name: let
        isLinuxScript = lib.hasSuffix linuxSuffix name;
        isDarwinScript = lib.hasSuffix darwinSuffix name;
        hasPlatformSuffix = isLinuxScript || isDarwinScript;
      in
        # If no platform suffix, include it (common script)
        # If has platform suffix, only include if matches current platform
        !hasPlatformSuffix || (isLinux && isLinuxScript) || (!isLinux && isDarwinScript)
    )
    allScriptFiles;

  # Create script packages, stripping platform suffix from name
  scripts =
    map (
      name: let
        # Strip platform suffix from script name for the command
        scriptName =
          if lib.hasSuffix linuxSuffix name
          then lib.removeSuffix linuxSuffix name
          else if lib.hasSuffix darwinSuffix name
          then lib.removeSuffix darwinSuffix name
          else name;
      in
        pkgs.writeShellScriptBin scriptName (builtins.readFile ./scripts/${name})
    )
    scriptFiles;
  opencode-bun = pkgs.callPackage ./opencode-bun/opencode-bun.nix {};

  # Platform-specific paths
  homeDir =
    if isLinux
    then "/home/viktor"
    else "/Users/viktor";

  # Common packages for all platforms
  commonPackages = with pkgs; [
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
    fastfetch
    hyperfine
    node2nix
    just
    apacheHttpd
    yazi
  ];

  # Linux-only packages
  linuxPackages = with pkgs; [
    kooha
    wl-clipboard
    docker
  ];

  # macOS-only packages
  darwinPackages = with pkgs; [
    # macOS-specific tools can go here
    # docker might need special handling on macOS
  ];
in {
  home.username = "viktor";
  home.homeDirectory = homeDir;
  xdg.configHome = "${homeDir}/.config";
  xdg.cacheHome = "${homeDir}/.cache";
  home.stateVersion = "24.11";

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
    ++ commonPackages
    ++ (lib.optionals isLinux linuxPackages)
    ++ (lib.optionals (!isLinux) darwinPackages)
    ++ scripts;

  programs = {
    zen-browser = {
      enable = isLinux;
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

  # Linux-specific session variables
  home.sessionVariables = lib.mkIf isLinux {
    GDK_BACKEND = "wayland";
  };

  # XDG mime apps - Linux only
  xdg.mimeApps = lib.mkIf isLinux (
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
    in {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    }
  );

  xdg.configFile."mimeapps.list".force = isLinux;
}
