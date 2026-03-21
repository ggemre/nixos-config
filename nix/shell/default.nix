{
  aux-nixpkgs,
  nixpkgs,
  self,
  ...
}:
self.lib.forAllSystems (
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
    auxpkgs = aux-nixpkgs.legacyPackages.${system};
  in {
    default = pkgs.mkShell {
      name = "Flake dev shell";
      packages = [
        pkgs.statix
        pkgs.deadnix
        pkgs.just
        pkgs.nil
        auxpkgs.alejandra-spaced
      ];
    };
  }
)
