{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkEnableOption mapAttrs removePrefix mkIf;
in {
  options.theme = {
    name = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "Name of the TOML theme file (without extension).";
    };

    colors = mkOption {
      type = types.attrsOf types.str;
      readOnly = true;
    };

    colorsWithHashtag = mkOption {
      type = types.attrsOf types.str;
      readOnly = true;
    };

    variant = mkOption {
      type = types.str;
      readOnly = true;
    };
  };

  config = let
    themePath = ./themes/${config.theme.name}.toml;
    rawTheme = builtins.fromTOML (builtins.readFile themePath);
    palette = rawTheme.palette;
  in {
    theme.colors = mapAttrs (_: v: removePrefix "#" v) palette;
    theme.colorsWithHashtag = palette;
    theme.variant = rawTheme.variant;
  };
}
