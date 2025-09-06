{
  nixpkgs,
  self,
}:
self.lib.forAllSystems (
  system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    hello = pkgs.callPackage ./hello {};
    alejandra-patched = pkgs.callPackage ./alejandra-patched {};
    zen-browser-unwrapped = pkgs.callPackage ./zen-browser {};
  }
)
