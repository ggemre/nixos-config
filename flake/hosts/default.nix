{
  nixpkgs,
  self,
}: let
  lib = import ../lib.nix {inherit nixpkgs;};
in {
  main = lib.mkHost "main" "x86_64-linux" self;
}
