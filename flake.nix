{
  description = "Nix flake to configure my entire \"fleet\" of systems.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
  outputs = args @ {
    self,
    nixpkgs,
    ...
  }: {
    lib = import ./lib args;
    nixosModules = import ./modules;
    overlays = import ./flake/overlays;
    nixosConfigurations = import ./hosts args;
    formatter = import ./flake/formatter args;
    devShells = import ./flake/shell args;
  };
}
