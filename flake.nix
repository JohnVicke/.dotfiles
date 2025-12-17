{
  description = "Home Manager configuration of viktor";

  inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixgl.url = "github:guibou/nixGL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    zen-browser,
    home-manager,
    nixgl,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          nixGL = nixgl.packages.${system};
          zen-browser = zen-browser.packages.${system}.beta;
        })
      ];
    };
    node_packages = import ./node_packages {
      inherit pkgs system;
      nodejs = pkgs.nodejs;
    };
  in {
    homeConfigurations."viktor" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit node_packages;};
      modules = [./modules/home.nix];
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
        home-manager
        just
        node2nix
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
