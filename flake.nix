{
  description = "Optimized Nix flake for all my NixOS systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    self,
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
