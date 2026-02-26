{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.brave;
in {
  options.programs.brave = {
    enable = lib.mkEnableOption "Whether to enable the Brave browser.";

    package = lib.mkPackageOption pkgs "brave" {};

    extraOpts = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra Brave policy options.";
    };

    initialPrefs = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Initial preferences are used to configure Helium for the first run.";
    };

    extensions = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "List of extensions to install.";
    };

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make Brave the default browser.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    programs.chromium = {
      enable = true;
      inherit (cfg) extraOpts initialPrefs extensions;
    };

    environment.variables = lib.mkIf cfg.defaultBrowser {
      BROWSER = cfg.package;
    };

    common.mime = lib.mkIf cfg.defaultBrowser {
      browser = "brave.desktop";
    };
  };
}
