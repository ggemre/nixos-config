{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.common.nix;
in {
  options.common.nix = {
    withLix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to use the lix package";
    };
  };

  config = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
      };
    };

    nix = {
      package =
        if cfg.withLix
        then pkgs.lixPackageSets.latest.lix
        else pkgs.nix;
      channel.enable = false;
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@wheel" ];
        auto-optimise-store = true;
        sandbox = true;
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.privatevoid.net"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        ];
      };
    };

    # Provide lix package to anyone who needs it
    programs.direnv.nix-direnv.package =
      lib.mkIf (
        config.programs.direnv.enable
        && config.programs.direnv.nix-direnv.enable
      ) (
        if cfg.withLix
        then pkgs.lixPackageSets.latest.nix-direnv
        else pkgs.nix-direnv
      );
  };
}
