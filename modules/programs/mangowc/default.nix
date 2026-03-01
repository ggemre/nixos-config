{
  config,
  lib,
  selfLib,
  ...
}: let
  cfg = config.programs.mangowc;
in {
  options.programs.mangowc = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the MangoWC configuration.";
    };

    autostart = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Autostart shell script run by MangoWC. (No need to include shebang).";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    environment.etc = {
      "mango/config.conf".text = selfLib.generators.hyprconf cfg.settings;

      "mango/autostart.sh" = lib.mkIf (cfg.autostart != "") {
        text = cfg.autostart;
      };
    };
  };
}
