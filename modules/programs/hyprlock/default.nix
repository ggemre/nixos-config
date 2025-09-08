{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.programs.hyprlock;
in {
  options.programs.hyprlock = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Hyprlock configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/hypr/hyprlock.conf".text = self.lib.generators.hyprconf cfg.settings;
  };
}
