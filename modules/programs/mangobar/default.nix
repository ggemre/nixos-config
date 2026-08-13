{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.mangobar;
in {
  options.programs.mangobar = {
    enable = lib.mkEnableOption "Whether to enable Mangobar.";

    package = lib.mkPackageOption pkgs "mangobar" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to Mangobar.";
    };

    style = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom CSS to apply to Mangobar.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    home = {
      ".config/mangobar/config.jsonc" = lib.mkIf (cfg.settings != {}) {
        source = (pkgs.formats.json {}).generate "mangobar-config.json" cfg.settings;
      };

      ".config/mangobar/style.css" = lib.mkIf (cfg.style != null) {
        source = pkgs.writeText "mangobar-style.css" cfg.style;
      };
    };
  };
}
