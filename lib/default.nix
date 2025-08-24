{nixpkgs, ...}: let
  # Configure the flake's supported systems
  # I know it's just one for now, but the infrastructure is there to support more
  supportedSystems = [
    "x86_64-linux"
    # "aarch64-linux"
    # "x86_64-darwin"
    # "aarch64-darwin"
  ];
in {
  # Function to generate attributes for each supported system
  forAllSystems = f:
    nixpkgs.lib.genAttrs supportedSystems
    f;

  # Function to generate a NixOS configuration
  mkHost = hostname: system: self:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit self;
        inherit (self) inputs;
      };
      modules = [
        self.nixosModules.common
        self.nixosModules.programs
        self.nixosModules.system
        self.nixosModules.homeless
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
}
