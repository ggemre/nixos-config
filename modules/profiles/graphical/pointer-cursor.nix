{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.graphical.pointerCursor;
  defaultIndexThemePackage = pkgs.writeTextFile {
    name = "index.theme";
    destination = "/share/icons/default/index.theme";
    text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cfg.name}
    '';
  };
in {
  options.graphical.pointerCursor = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "Package providing the cursor theme.";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = "The cursor name within the package.";
    };

    size = lib.mkOption {
      type = lib.types.int;
      default = 32;
      description = "The cursor size.";
    };

    dotIcons = {
      enable = lib.mkEnableOption "~/.icons config generation";
    };
  };

  config = lib.mkIf (cfg.package != null && cfg.name != null) {
    environment = {
      systemPackages = [
        cfg.package
        defaultIndexThemePackage
      ];

      variables = {
        XCURSOR_SIZE = cfg.size;
        XCURSOR_THEME = cfg.name;
      };
    };

    homeless =
      {
        ".local/share/icons/default/index.theme".source = "${defaultIndexThemePackage}/share/icons/default/index.theme";
        ".local/share/icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
      }
      // lib.optionalAttrs cfg.dotIcons.enable {
        ".icons/default/index.theme".source = "${defaultIndexThemePackage}/share/icons/default/index.theme";
        ".icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
      };
  };
}
