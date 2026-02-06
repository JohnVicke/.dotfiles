{
  description = "Home Manager configuration of johnvicke";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nixgl.url = "github:guibou/nixGL";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    nixgl,
    ...
  }: let
    # Supported platforms
    supportedSystems = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # Helper to check if system is Linux
    isLinux = system: nixpkgs.lib.hasSuffix "-linux" system;

    # Helper to generate configs for each system
    forEachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                (final: prev: {
                  nixGL =
                    if isLinux system
                    then nixgl.packages.${system}
                    else {};
                })
              ];
            };
          }
      );

    # Get node packages for a system
    nodePackagesFor = pkgs: system:
      import ./node_packages {
        inherit pkgs system;
        nodejs = pkgs.nodejs;
      };

    # Common special args for home-manager
    mkSpecialArgs = pkgs: system: {
      node_packages = nodePackagesFor pkgs system;
      inherit system;
      isLinux = isLinux system;
    };

    # User configuration
    mkHomeConfiguration = {
      username,
      homeDirectory,
      system,
      extraModules ? [],
    }: let
      pkgs = (forEachSystem (args: args.pkgs)).${system};
      linux = isLinux system;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkSpecialArgs pkgs system;
        modules =
          [
            ./modules/home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
              home.stateVersion = "24.11";
            }
            (nixpkgs.lib.optionalAttrs linux {
              xdg.configHome = "${homeDirectory}/.config";
              xdg.cacheHome = "${homeDirectory}/.cache";
            })
          ]
          ++ extraModules;
      };
  in {
    # Home configurations for all platforms
    homeConfigurations = {
      # Linux desktop
      "johnvicke" = mkHomeConfiguration {
        username = "johnvicke";
        homeDirectory = "/home/johnvicke";
        system = "x86_64-linux";
        extraModules = [
          ./modules/linux
          zen-browser.homeModules.beta
        ];
      };

      # macOS (Apple Silicon)
      "viktor" = mkHomeConfiguration {
        username = "viktor";
        homeDirectory = "/Users/viktor";
        system = "aarch64-darwin";
        extraModules = [
          ./modules/darwin/home.nix
          zen-browser.homeModules.beta
        ];
      };
    };

    # Dev shells for each platform
    devShells = forEachSystem (
      {pkgs, ...}: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            just
            node2nix
          ];
        };
      }
    );

    # Formatters for each platform
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
