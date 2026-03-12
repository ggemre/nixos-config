{
  config,
  lib,
  pkgs,
  selfLib,
  ...
}: let
  cfg = config.programs.mangowm;
in {
  options.programs.mangowm = {
    # TODO: rm these once nixpkgs module is renamed
    enable = lib.mkEnableOption "Whether to enable MangoWM.";
    package = lib.mkPackageOption pkgs "mangowc" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the MangoWM configuration.";
    };

    autostart = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Autostart shell script run by MangoWM. (No need to include shebang).";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: rm once nixpkgs module is renamed
    programs.mangowc = {
      enable = true;
      inherit (cfg) package;
    };

    environment.variables = {
      XDG_CURRENT_DESKTOP = "mango";
      XDG_SESSION_DESKTOP = "mango";
    };

    environment.etc = {
      "mango/config.conf".text = selfLib.generators.toMangoConf cfg.settings;

      "mango/autostart.sh" = lib.mkIf (cfg.autostart != "") {
        text = cfg.autostart;
      };
    };
  };
}
