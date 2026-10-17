{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.keepassxc;
in {
  options.programs.keepassxc = {
    enable = lib.mkEnableOption "Whether to enable KeePassXC.";

    package = lib.mkPackageOption pkgs "keepassxc" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Configuration settings for KeePassXC.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    home = {
      ".config/keepassxc/keepassxc.ini" = lib.mkIf (cfg.settings != {}) {
        text = lib.generators.toINI {} cfg.settings;
      };
    };
  };
}
