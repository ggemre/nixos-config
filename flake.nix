{
  description = "Optimized Nix flake for all my NixOS systems.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules = import ./modules;
    nixosConfigurations = import ./hosts inputs;
    formatter = import ./nix/formatter inputs;
    devShells = import ./nix/shell inputs;
    packages = import ./pkgs inputs;
    lib = import ./lib inputs;
  };
}
