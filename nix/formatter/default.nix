{
  nixpkgs,
  self,
}:
self.lib.forAllSystems (
  system: let
    # pkgs = import nixpkgs {inherit system;};
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
    };
  in
    pkgs.patched.alejandra
)
