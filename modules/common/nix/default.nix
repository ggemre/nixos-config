{
  lib,
  pkgs,
  ...
}: {
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
      package = pkgs.lixPackageSets.latest.lix;
      channel.enable = false;
      gc.automatic = false;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@wheel" ];
        auto-optimise-store = true;
        sandbox = true;
        warn-dirty = false;
        allow-import-from-derivation = false;

        substituters = [
          "https://cache.privatevoid.net?priority=2"
          "https://nix-community.cachix.org?priority=3"
        ];
        trusted-public-keys = [
          "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        http-connections = 64;
        max-substitution-jobs = 32;

        # Fallback quickly if substituters are not available
        connect-timeout = 5;
        fallback = true;
      };
    };

    # Provide lix package to anyone who needs it
    programs.direnv.nix-direnv.package = pkgs.lixPackageSets.latest.nix-direnv;
  };
}
