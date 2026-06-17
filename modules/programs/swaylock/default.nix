# Thanks to Home Manager for the configuration generator.
# https://github.com/nix-community/home-manager/blob/df4e0465717a2d34f05b8ccd967275aaf3ceaa01/modules/programs/swaylock.nix#L81
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.swaylock;
in {
  options.programs.swaylock = {
    enable = lib.mkEnableOption "Whether to enable Swaylock.";

    package = lib.mkPackageOption pkgs "swaylock" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Swaylock configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    home.".config/swaylock/config" = lib.mkIf (cfg.settings != {}) {
      text = lib.concatStrings (
        lib.mapAttrsToList (
          n: v:
            if v == false
            then ""
            else
              (
                if v == true
                then n
                else
                  n
                  + "="
                  + (
                    if builtins.isPath v
                    then "${v}"
                    else toString v
                  )
              )
              + "\n"
        )
        cfg.settings
      );
    };

    security.pam.services.swaylock = {};
  };
}
