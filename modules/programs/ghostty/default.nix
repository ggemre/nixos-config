{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ghostty;

  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "Whether to enable the ghostty terminal emulator";

    package = lib.mkPackageOption pkgs "ghostty" { example = "pkgs.ghostty"; };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the ghostty configuration.";
    };
    theme = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Colors to apply to the ghostty theme.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    home = {
      ".config/ghostty/config".source =
        keyValue.generate "ghostty-config"
        (cfg.settings
          // {
            theme = "custom";
          });

      ".config/ghostty/themes/custom".source = keyValue.generate "ghostty-theme" cfg.theme;
    };
  };
}
