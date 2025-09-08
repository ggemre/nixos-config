{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.services.hypridle;
in {
  options.services.hypridle = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to Hypridle.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/hypr/hypridle.conf".text = self.lib.generators.hyprconf cfg.settings;
  };
}
