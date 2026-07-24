{self, ...}:
self.lib.forAllSystems (
  system: self.packages.${system}.alejandra-spaced
)
