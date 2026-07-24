{
  nixpkgs,
  self,
  ...
}:
self.lib.forAllSystems (
  system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    alejandra-spaced = pkgs.callPackage ./alejandra-spaced {};
    mango = pkgs.callPackage ./mango {};
  }
)
