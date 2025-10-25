{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.waybar;
in {
  options.programs.waybar = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to Waybar.";
    };

    style = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom CSS to apply to Waybar.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.".config/waybar/config" = lib.mkIf (cfg.settings != {}) {
      source = (pkgs.formats.json {}).generate "waybar-config.json" cfg.settings;
    };

    home.".config/waybar/style.css" = lib.mkIf (cfg.style != null) {
      source = pkgs.writeText "waybar-style.css" cfg.style;
    };
  };
}
