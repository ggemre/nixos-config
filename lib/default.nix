{nixpkgs, ...}: let
  # Configure the flake's supported systems
  # I know it's just one for now, but the infrastructure is there to support more
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
    # "x86_64-darwin"
    # "aarch64-darwin"
  ];

  inherit (nixpkgs) lib;
in {
  # Function to generate attributes for each supported system
  forAllSystems = f:
    lib.genAttrs supportedSystems
    f;

  # Function to collect modules in a directory into a list
  collectModules = path:
    lib.mapAttrsToList (n: _: path + "/${n}")
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));

  # Basic color formatting functions for theming
  colors = {
    rgb = color: "rgb(${color})";
    rgba = color: alpha: "rgba(${color}${alpha})";
    hexa = color: alpha: "0x${color}${alpha}";
  };

  # Functions for generating different configuration formats from nix attrs
  generators = {
    toHyprConf = import ./generators/hyprconf.nix { inherit lib; };
    toMangoConf = import ./generators/mangoconf.nix { inherit lib; };
  };
}
