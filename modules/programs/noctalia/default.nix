{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.noctalia;

  jsonFormat = pkgs.formats.json {};
in {
  options.programs.noctalia = {
    enable = lib.mkEnableOption "Whether to enable the Noctalia shell.";
    package = lib.mkPackageOption pkgs "noctalia-shell" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the Noctalia configuration.";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Colors to apply to the Noctalia theme.";
    };

    plugins = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Plugin configuration for Noctalia shell.";
    };

    pluginSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Individual settings to apply to each plugin.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    home =
      {
        ".config/noctalia/settings.json" = lib.mkIf (cfg.settings != {}) {
          source = jsonFormat.generate "noctalia-settings" cfg.settings;
        };

        ".config/noctalia/colors.json" = lib.mkIf (cfg.colors != {}) {
          source = jsonFormat.generate "noctalia-colors" cfg.colors;
        };

        ".config/noctalia/plugins.json" = lib.mkIf (cfg.plugins != {}) {
          source = jsonFormat.generate "noctalia-plugins" cfg.plugins;
        };
      }
      // lib.mapAttrs' (
        name: value:
          lib.nameValuePair "noctalia/plugins/${name}/settings.json" {
            source = jsonFormat.generate "${name}-settings" value;
          }
      )
      cfg.pluginSettings;
  };
}
