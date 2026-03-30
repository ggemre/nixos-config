{
  aux-nixpkgs,
  nixpkgs,
  self,
  ...
}: let
  mkHost = system: hostname:
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        selfLib = self.lib;
        selfModules = self.nixosModules;
        auxpkgs = aux-nixpkgs.legacyPackages.${system};
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
          };
        }
        ../hosts/${hostname}
      ];
    };
in {
  corvus = mkHost "aarch64-linux" "corvus";
  orion = mkHost "x86_64-linux" "orion";
}
