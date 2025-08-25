{
  nixpkgs,
  self,
}:
self.lib.forAllSystems (
  system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    default = pkgs.mkShell {
      name = "Flake dev shell";
      packages = [
        pkgs.statix
        pkgs.deadnix
        pkgs.disko
        pkgs.just
      ];
    };
  }
)
