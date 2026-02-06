# Main home configuration - imports platform-specific modules
{
  config,
  lib,
  pkgs,
  node_packages,
  isLinux,
  isDarwin,
  system,
  ...
}: {
  # This file serves as the entry point and imports platform-specific modules
  # Platform detection is done via isLinux and isDarwin passed from flake.nix

  imports = [
    # Always import shared configuration
    ./shared

    # Platform-specific imports handled in flake.nix per-platform
    # Linux: imports ./linux/default.nix
    # Darwin: imports ./darwin/home.nix
  ];

  # Any additional per-user overrides can go here
}
