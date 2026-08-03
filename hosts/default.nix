{
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
        selfPkgs = self.packages.${system};
      };

      modules = [
        ../hosts/${hostname}
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
      ];
    };

  mkImage = system: hostname:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ../hosts/${hostname}
        {
          config.nixpkgs.hostPlatform = system;
        }
      ];
    };
in {
  corvus = mkHost "aarch64-linux" "corvus"; # rpi4 server
  lupus = mkHost "x86_64-linux" "lupus"; # testbed VM
  orion = mkHost "x86_64-linux" "orion"; # main laptop
  tucana = mkHost "x86_64-linux" "tucana"; # backup laptop

  australis = mkImage "aarch64-linux" "australis"; # sd-image installer
  polaris = mkImage "x86_64-linux" "polaris"; # cd-dvd installer
}
