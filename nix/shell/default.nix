{
  nixpkgs,
  nur,
  self,
  ...
}:
self.lib.forAllSystems (
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
    nurPkgs = nur.legacyPackages.${system}.repos;
  in {
    default = pkgs.mkShell {
      name = "Flake dev shell";
      packages = [
        pkgs.statix
        pkgs.deadnix
        pkgs.just
        pkgs.nil
        nurPkgs.ggemre.alejandra-spaced
      ];
    };
  }
)
