{
  nixpkgs,
  self,
}: let
  lib = import ../lib {inherit nixpkgs;};
in {
  main = lib.mkHost "main" "x86_64-linux" self;
}

