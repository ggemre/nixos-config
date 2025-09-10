{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.services.hyprsunset;
in {
  options.services.hyprsunset = {
    enable = lib.mkEnableOption "Whether to enable the Hyprsunset service.";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Hyprsunset configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/hypr/hyprsunset.conf".text = self.lib.generators.hyprconf cfg.settings;
  };
}
