# Linux-specific home configuration
{
  config,
  lib,
  pkgs,
  node_packages,
  ...
}: {
  # Linux GUI and wayland packages
  home.packages = with pkgs; [
    node_packages."@github/copilot"
    kooha
    wl-clipboard
  ];

  # Note: xdg directories are set in flake.nix per-platform

  # Enable XDG mime apps and set Zen as default browser
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
    };
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;

  # Session variables for Linux
  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };

  imports = [
    ../waybar/waybar.nix
    ../hyprland/hyprland.nix
  ];
}
