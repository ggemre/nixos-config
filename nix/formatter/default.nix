{
  aux-nixpkgs,
  self,
  ...
}:
self.lib.forAllSystems (
  system: aux-nixpkgs.legacyPackages.${system}.alejandra-spaced
)
