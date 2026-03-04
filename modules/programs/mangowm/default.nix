{
  config,
  lib,
  selfLib,
  ...
}: let
  cfg = config.programs.mangowm;
in {
  options.programs.mangowm = {
    enable = lib.mkEnableOption "Whether to enable MangoWM.";

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
    # TODO: rm when nixpkgs gets with the times
    programs.mangowc.enable = true;

    environment.variables = {
      XDG_CURRENT_DESKTOP = "mango";
      XDG_SESSION_DESKTOP = "mango";
    };

    environment.etc = {
      "mango/config.conf".text = selfLib.generators.hyprconf cfg.settings;

      "mango/autostart.sh" = lib.mkIf (cfg.autostart != "") {
        text = cfg.autostart;
      };
    };
  };
}
