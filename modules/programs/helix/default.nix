{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.helix;
  tomlFormat = pkgs.formats.toml {};

  themeName = builtins.replaceStrings [ "-" ] [ "_" ] config.theme.name;
  finalSettings = cfg.settings // lib.optionalAttrs cfg.theme.enable { theme = themeName; };
in {
  options.programs.helix = {
    enable = lib.mkEnableOption "Whether to enable the helix text editor.";

    package = lib.mkPackageOption pkgs "helix" { example = "pkgs.evil-helix"; };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set the default editor to helix.";
    };

    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = {};
      description = "Settings for the helix editor.";
    };

    theme.enable =
      lib.mkEnableOption "consistent theming"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    home.".config/helix/config.toml".source = tomlFormat.generate "helix.toml" finalSettings;

    environment.variables = lib.mkIf cfg.defaultEditor {
      EDITOR = lib.getExe cfg.package;
    };

    common.mime = lib.mkIf cfg.defaultEditor {
      editor = "Helix.desktop";
    };
  };
}
