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
    launcher = lib.mkPackageOption pkgs "wofi" {}; # e.g. wofi needs ``--show drun`
    bar = lib.mkPackageOption pkgs "waybar" {};
  };

  config = {
    environment.variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    # TODO: theming
    environment.etc."xdg/hypr/hyprland.conf".source = pkgs.replaceVars ./variants/${cfg.variant}/hyprland.conf {
      terminal = lib.getExe cfg.terminal;
      browser = lib.getExe cfg.browser;
      launcher = lib.getExe cfg.launcher;
      bar = lib.getExe cfg.bar;
    };
  };
}
