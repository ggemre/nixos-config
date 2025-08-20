{nixpkgs, ...}: let
  lib = import ../../lib {inherit nixpkgs;};
in
  lib.forAllSystems (
    system: let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.alejandra
  )
