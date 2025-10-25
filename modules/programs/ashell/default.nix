{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ashell;
  tomlFormat = pkgs.formats.toml {};
in {
  options.programs.ashell = {
    enable = lib.mkEnableOption "Whether to enable the ashell status bar.";

    package = lib.mkPackageOption pkgs "ashell" {};

    settings = lib.mkOption {
      type = lib.types.nullOr tomlFormat.type;
      default = {};
      description = "Configuration settings for ashell.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ashell
    ];

    home.".config/ashell/config.toml" = lib.mkIf (cfg.settings != {}) {
      source = tomlFormat.generate "ashell-config" cfg.settings;
    };
  };
}
