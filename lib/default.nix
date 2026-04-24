{nixpkgs, ...}: let
  # Configure the flake's supported systems
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
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

  # Generate a list of public keys for my workstations
  # Uses GitHub, but you can easily migrate to CodeBerg
  pubkeys = let
    keysFile = builtins.readFile (builtins.fetchurl {
      url = "https://github.com/ggemre.keys";
      sha256 = "sha256-/6AAl/wauClt+WtkuEZw3MX+tEnIQZ1XqN4yjCHnUYU=";
    });
  in
    lib.strings.splitString "\n" (lib.strings.trim keysFile);

  # Functions for generating different configuration formats from nix attrs
  generators = {
    toHyprConf = import ./generators/hyprconf.nix { inherit lib; };
    toMangoConf = import ./generators/mangoconf.nix { inherit lib; };
  };
}
