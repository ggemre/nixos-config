{
  config,
  lib,
  selfLib,
  ...
}: let
  cfg = config.programs.mango;
in {
  options.programs.mango = {
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
