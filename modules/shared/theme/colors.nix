{
  config,
  lib,
  ...
}: {
  options.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-mocha";
      description = "Name of the TOML theme file (without extension).";
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
    };

    colorsWithHashtag = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
    };

    variant = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
    };
  };

  config = let
    themePath = ./themes/${config.theme.name}.toml;
    rawTheme = builtins.fromTOML (builtins.readFile themePath);
    inherit (rawTheme) palette;
  in {
    theme = {
      colors = lib.mapAttrs (_: v: lib.removePrefix "#" v) palette;
      colorsWithHashtag = palette;
      inherit (rawTheme) variant;
    };
  };
}
