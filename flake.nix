{
  description = "Nix flake to configure my entire \"fleet\" of systems.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules = import ./modules;
    overlays = import ./flake/overlays;
    nixosConfigurations = import ./hosts inputs;
    formatter = import ./flake/formatter inputs;
    devShells = import ./flake/shell inputs;
  };
}
