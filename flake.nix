{
  description = "Optimized Nix flake for all my NixOS systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aux-nixpkgs = {
      url = "github:ggemre/aux-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    aux-nixpkgs,
    self,
    ...
  }: {
    nixosModules = import ./modules;
    nixosConfigurations = import ./hosts inputs;
    formatter = import ./nix/formatter inputs;
    devShells = import ./nix/shell inputs;
    lib = import ./lib inputs;
  };
}
