{
  nixpkgs,
  self,
}:
self.lib.forAllSystems (
  system: let
    pkgs = import nixpkgs {
      inherit system;
    };
  in
    self.packages.${system}.alejandra-patched
)
