{
  config,
  lib,
  pkgs,
  selfLib,
  ...
}: let
  cfg = config.programs.kwm;
in {
  options.programs.kwm = {
    enable = lib.mkEnableOption "Whether to enable the kewuaa's window manager.";
    package = lib.mkPackageOption pkgs "hello" {};
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the kwm configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
        pkgs.river
      ];

      variables = {
        XDG_CURRENT_DESKTOP = "river";
        XDG_SESSION_DESKTOP = "river";
      };
    };

    home.".config/kwm/config.zon".text = selfLib.generators.toZon cfg.settings;
  };
}
