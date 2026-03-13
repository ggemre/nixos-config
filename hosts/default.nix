{
  nixpkgs,
  nur,
  self,
  ...
}: let
  mkHost = system: hostname:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        selfLib = self.lib;
        selfModules = self.nixosModules;
        nurPkgs = nur.legacyPackages.${system}.repos;
      };
      modules = [
        self.nixosModules.common
        self.nixosModules.home
        self.nixosModules.programs
        self.nixosModules.services
        self.nixosModules.theme
        {
          config = {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nur.flake = nur;
            };
          };
        }
        ../hosts/${hostname}
      ];
    };
in {
  orion = mkHost "x86_64-linux" "orion";
}
