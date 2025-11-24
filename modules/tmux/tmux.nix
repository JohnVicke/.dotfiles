{ config, pkgs, ... }:

{
  programs = {
    tmux = {
      enable = true;
      sensibleOnTop = false;
      extraConfig = ''
                set -g default-terminal "xterm-256color"
                set-option -ga terminal-overrides ",xterm-256color:RGB"
        # Vague theme colors
                vague_bg="#141415"
                vague_fg="#cdcdcd"
                vague_selection="#252530"
                vague_muted="#606079"
                vague_accent="#6e94b2"

        # Status bar configuration
                set -g status-style "bg=$vague_bg,fg=$vague_fg"
                set -g status-left-length 50
                set -g status-right-length 50

        # Left: Directory name (muted)
                set -g status-left "#[fg=$vague_muted]#{b:session_path} "

        # Center: Windows
                set -g status-justify centre
                set -g window-status-format "#[fg=$vague_muted] #I:#W "
                set -g window-status-current-format "#[fg=$vague_fg] #I:#W "

        # Right: Time (minimal)
                set -g status-right ""

        # Window status separator
                set -g window-status-separator ""

        # Remove default window status styling
                set -g window-status-style "none"
                set -g window-status-current-style "none"

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
                bind-key -r f run-shell "tmux neww tmux-sessionizer"
                bind-key -r u run-shell "up"
                bind-key -r g new-window -c '#{pane_current_path}'  -n '' lazygit
                bind-key -r v new-window -c '#{pane_current_path}'  -n '' lazydocker
                bind-key -r 9 new-window -c '#{pane_current_path}'  -n '⎈' k9s 
                bind-key -r x kill-pane 
      '';
    };
  };
}
