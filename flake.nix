{
  description = "Insanely optimized Nix flake for all my NixOS systems.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules = import ./modules;
    overlays = import ./overlays;
    lib = import ./lib inputs;
    nixosConfigurations = import ./hosts inputs;
    formatter = import ./nix/formatter inputs;
    devShells = import ./nix/shell inputs;
  };
}
