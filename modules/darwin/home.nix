# macOS-specific home configuration
{
  config,
  lib,
  pkgs,
  ...
}: {
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS-specific tools
    terminal-notifier
  ];

  # macOS-specific file locations
  home.file = {
    # macOS-specific dotfiles can go here
  };

  # Programs that need macOS-specific config
  programs = {
    # Terminal notifier integration
    zsh.initExtra = lib.mkAfter ''
      # macOS-specific zsh settings
      export HOMEBREW_NO_AUTO_UPDATE=1
    '';
  };

  # Disable Linux-specific settings
  xdg.mimeApps.enable = lib.mkForce false;
}
