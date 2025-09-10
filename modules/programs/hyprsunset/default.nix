{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.programs.hyprsunset;
in {
  options.programs.hyprsunset = {
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
