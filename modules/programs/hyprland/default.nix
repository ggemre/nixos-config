{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.programs.hyprland;
in {
  options.programs.hyprland = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Hyprland configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    programs.hyprland = {
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    environment.etc."xdg/hypr/hyprland.conf".text = self.lib.generators.hyprconf cfg.settings;
  };
}
