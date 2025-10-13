{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.services.hyprsunset;
in {
  options.services.hyprsunset = {
    enable = lib.mkEnableOption "Whether to enable the Hyprsunset service.";

    package = lib.mkPackageOption pkgs "hyprsunset" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Hyprsunset configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/hypr/hyprsunset.conf".text = self.lib.generators.hyprconf cfg.settings;
    };
  };
}
