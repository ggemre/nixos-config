{
  nixpkgs,
  self,
}: let
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
  mkHost = hostname:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self;
      };
      modules = [
        self.nixosModules.common
        self.nixosModules.homeless
        self.nixosModules.theme
        {
          config.networking.hostName = hostname;
        }
        ../hosts/${hostname}
      ];
    };

  # Basic color formatting functions for theming
  colors = {
    rgb = color: "rgb(${color})";
    rgba = color: alpha: "rgba(${color}${alpha})";
    ron = import ./hex2rgba.nix { inherit (nixpkgs) lib; };
  };

  # Functions for generating different configuration formats from nix attrs
  generators = {
    hyprconf = import ./generators/hyprconf.nix { inherit (nixpkgs) lib; };
    kdl = import ./generators/kdl.nix { inherit (nixpkgs) lib; };
    ron = import ./generators/ron.nix { inherit (nixpkgs) lib; };
  };
}
