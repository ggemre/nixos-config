{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.btop;

  finalSettings =
    if cfg.theme != {}
    then cfg.settings // { color_theme = "custom"; }
    else cfg.settings;
in {
  options.programs.btop = {
    enable = lib.mkEnableOption "Whether to enable the btop resource monitor";

    package = lib.mkPackageOption pkgs "btop" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Configuration settings for btop.";
    };

    theme = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Custom theme to apply to btop.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    home = {
      ".config/btop/btop.conf" = lib.mkIf (finalSettings != {}) {
        text = lib.generators.toKeyValue {} finalSettings;
      };

      ".config/btop/themes/custom.theme" = lib.mkIf (cfg.theme != {}) {
        text = lib.generators.toKeyValue {} cfg.theme;
      };
    };
  };
}
