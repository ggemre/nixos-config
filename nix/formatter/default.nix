{
  nur,
  self,
  ...
}:
self.lib.forAllSystems (
  system: nur.legacyPackages.${system}.repos.ggemre.alejandra-spaced
)
