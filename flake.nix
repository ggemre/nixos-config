{
  description = "Optimized Nix flake for all my NixOS systems.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = inputs @ {
    nixpkgs,
    self,
    ...
  }: {
    nixosModules = import ./modules;
    nixosConfigurations = import ./hosts inputs;
    packages = import ./pkgs inputs;
    formatter = import ./nix/formatter inputs;
    devShells = import ./nix/shell inputs;
    lib = import ./lib inputs;
  };
}
