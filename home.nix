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
    unzip
  ];

  programs = {
    home-manager = {enable = true; };
    kitty = {
      enable = true;
      font = {
        name = "MonaspiceAr Nerd Font";
      };
      settings = {
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/mykitty";
        kitty_mod = "ctrl+shift";
        shell_integration = "enabled";
        action_alias =
          "kitty_scrollback_nvim kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
        font_size = "8.0";
      };
      keybindings = {
        # Browse scrollback buffer in nvim
        "ctrl+f" = "kitty_scrollback_nvim --nvim-args -n";
        # Browse output of the last shell command in nvim
        "kitty_mod+g" =
          "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      };
      themeFile = "kanagawa";
    };
    neovim = { enable = true; };
    tmux = { enable = true; };
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
    ".zshrc".source = ./zsh/.zshrc;
    ".tmux.conf".source = ./tmux/.tmux.conf;
    "bin/.local".source = ./bin/.local;
    ".config/starship.toml".source = ./starship/config.toml;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };

}
