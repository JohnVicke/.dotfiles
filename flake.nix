{
  description = "Home Manager configuration of viktor";

  inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixgl.url = "github:guibou/nixGL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    zen-browser,
    home-manager,
    nixgl,
    ...
  }: let
    # Supported platforms
    supportedSystems = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # Helper to generate configs for each system
    forEachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (
                  final: prev: let
                    isLinux = nixpkgs.lib.hasSuffix "-linux" system;
                  in {
                    # Only add nixGL on Linux
                    nixGL =
                      if isLinux
                      then nixgl.packages.${system}
                      else {};
                    # Zen browser only on Linux
                    zen-browser =
                      if isLinux
                      then zen-browser.packages.${system}.beta
                      else null;
                  }
                )
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
  in {
    # Home configurations for each platform
    homeConfigurations = nixpkgs.lib.genAttrs supportedSystems (
      system: let
        pkgs = (forEachSystem (args: args.pkgs)).${system};
        isLinux = nixpkgs.lib.hasSuffix "-linux" system;
        node_packages = nodePackagesFor pkgs system;
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit node_packages;
            inherit isLinux;
            system = system;
          };
          modules =
            [
              ./modules/home.nix
            ]
            ++ (nixpkgs.lib.optional isLinux zen-browser.homeModules.beta);
        }
    );

    # Dev shells for each platform
    devShells = forEachSystem (
      {pkgs, ...}: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            home-manager
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
