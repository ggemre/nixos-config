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
    mangobar = pkgs.callPackage ./mangobar {};
    mozilla-addons = pkgs.callPackage ./mozilla-addons {};
  }
)
