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
    docker
  ];

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
    neovim = { enable = true; };
    tmux = { 
      sensibleOnTop = false;
      baseIndex = 0;
      enable = true; 
      plugins = with pkgs; [
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = '' 
          set -g @rose_pine_variant 'main' 
          set -g @rose_pine_bar_bg_disable 'on'
          '';
      }
      ];
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:RGB"

        set -s escape-time 0

        unbind c-b
        set-option -g prefix c-t
        bind-key c-t send-prefix

        set -g base-index 1

        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        bind r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded";
      set -g mouse on

        set-window-option -g mode-keys vi;

      bind V copy-mode;

      bind -T copy-mode-vi V send-keys -X cancel

        unbind -T copy-mode-vi v

        bind -T copy-mode-vi v \
        send-keys -X begin-selection

        bind -T copy-mode-vi 'C-v' \
        send-keys -X rectangle-toggle

        bind -T copy-mode-vi y \
        send-keys -X copy-pipe-and-cancel "pbcopy"

        bind -T copy-mode-vi MouseDragEnd1Pane \
        send-keys -X copy-pipe-and-cancel "pbcopy"

        set-option -g status-position top 

        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R

        bind -n M-h resize-pane -L 5
        bind -n M-j resize-pane -D 5
        bind -n M-k resize-pane -U 5
        bind -n M-l resize-pane -R 5

        bind-key 'w' choose-tree -Zs
        bind-key -r a run-shell "tmux-sessionizer ~/dev/anyfin/deposits-service"
        bind-key -r s run-shell "tmux-sessionizer ~/.dotfiles"
        bind-key -r f run-shell "tmux neww tmux-sessionizer"
        bind-key -r u run-shell "up"
        bind-key -r g new-window -c '#{pane_current_path}'  -n '' lazygit
        bind-key -r v new-window -c '#{pane_current_path}'  -n '' lazydocker
        bind-key -r 9 new-window -c '#{pane_current_path}'  -n '⎈' k9s 
        bind-key -r x kill-pane 
      '';
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
    ".zshrc".source = ./zsh/.zshrc;
    "bin/.local".source = ./bin/.local;
    ".config/starship.toml".source = ./starship/config.toml;
    ".config/ghostty/themes".source = ./ghostty/themes;
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };
}
