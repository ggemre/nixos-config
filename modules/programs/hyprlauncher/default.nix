{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.programs.hyprlauncher;
in {
  options.programs.hyprlauncher = {
    enable = lib.mkEnableOption "Whether to enable Hyprlauncher.";

    package = lib.mkPackageOption pkgs "hyprlauncher" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Hyprlauncher configuration.";
    };

    style = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Theme to apply to Hyprtoolkit.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc."xdg/hypr/hyprlauncher.conf" = lib.mkIf (cfg.settings != {}) {
        text = self.lib.generators.hyprconf cfg.settings;
      };
      etc."xdg/hypr/hyprtoolkit.conf" = lib.mkIf (cfg.style != {}) {
        text = self.lib.generators.hyprconf cfg.style;
      };
    };
  };
}
