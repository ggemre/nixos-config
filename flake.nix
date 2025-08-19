{
  description = "Nix flake to configure my entire \"fleet\" of systems.";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.privatevoid.net"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules = import ./modules;
    nixosConfigurations = import ./hosts inputs;
    formatter = import ./flake/formatter inputs;
    devShells = import ./flake/shell inputs;
  };
}
