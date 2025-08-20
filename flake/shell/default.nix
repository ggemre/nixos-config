{nixpkgs, ...}: let
  lib = import ../../lib {inherit nixpkgs;};
in
  lib.forAllSystems (
    system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        name = "Fleet dev shell";
        packages = [
          pkgs.statix
          pkgs.deadnix
        ];
      };
    }
  )
