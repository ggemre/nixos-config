{
  description = "Insanely optimized Nix flake for all my NixOS systems.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
  outputs = args @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules = import ./modules;
    overlays = import ./overlays;
    lib = import ./lib args;
    nixosConfigurations = import ./hosts args;
    formatter = import ./nix/formatter args;
    devShells = import ./nix/shell args;
  };
}
