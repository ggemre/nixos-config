{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
  generator = import ./generator.nix { inherit lib; };

  variants = {
    amethyst = import ./variants/amethyst;
  };

  context = builtins.mapAttrs (_: v: lib.getExe v.package) cfg.context;
  selectedVariant = variants.${cfg.variant} context;
in {
  options.programs.hyprland = {
    variant = lib.mkOption {
      type = lib.types.str;
      description = "The specific config of Hyprland to install.";
      default = "amethyst";
    };

    context = {
      terminal.package = lib.mkPackageOption pkgs "foot" {};
      browser.package = lib.mkPackageOption pkgs "firefox" {};
      launcher.package = lib.mkPackageOption pkgs "wofi" {};
      launcher.extraArgs = lib.mkOption {
        type = lib.types.str;
        default = "--show drun";
        description = "Extra arguments passed to the launcher.";
      };
      bar.package = lib.mkPackageOption pkgs "waybar" {};
    };
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
    environment.etc."xdg/hypr/hyprland.conf".text = generator.toHyprConf selectedVariant;
  };
}
