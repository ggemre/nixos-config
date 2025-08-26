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

  config = lib.mkIf cfg.enable {
    environment.variables = {
      XCURSOR_SIZE = 10;
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # Toolkit backends
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # QT specifics
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      # Application specifics
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = 1;
    };

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
