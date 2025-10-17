{
  nixpkgs,
  self,
}:
self.lib.forAllSystems (
  system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    alejandra-patched = pkgs.callPackage ./alejandra-patched {};
    dwl = pkgs.callPackage ./dwl {};
    hello = pkgs.callPackage ./hello {};
    zen-browser-unwrapped = pkgs.callPackage ./zen-browser {};
  }
)
