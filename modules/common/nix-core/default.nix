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
        warn-dirty = false;
        allow-import-from-derivation = false;

        substituters = [
          "https://cache.nixos.org?priority=1"
          "https://nix-community.cachix.org?priority=2"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        # Fallback quickly if substituters are not available
        connect-timeout = 5;
        fallback = true;
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
