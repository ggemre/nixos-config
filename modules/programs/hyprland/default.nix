{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
in {
  options.programs.hyprland = {
    variant = lib.mkOption {
      type = lib.types.str;
      description = "The specific config of Hyprland to install.";
      default = "amethyst";
    };
    # TODO: should these have a parent option?
    # TODO: Should they have suboptions e.g. package & extraArgs?
    terminal = lib.mkPackageOption pkgs "foot" {};
    browser = lib.mkPackageOption pkgs "firefox" {};
    launcher = lib.mkPackageOption pkgs "wofi" {};
    bar = lib.mkPackageOption pkgs "waybar" {};
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    # TODO: theming
    homeless.".config/hypr/hyprland.conf".source = pkgs.replaceVars ./variants/${cfg.variant}/hyprland.conf {
      terminal = lib.getExe cfg.terminal;
      browser = lib.getExe cfg.browser;
      launcher = lib.getExe cfg.launcher;
      bar = lib.getExe cfg.bar;
    };
  };
}
