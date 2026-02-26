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
      description = "Extra brave policy options.";
    };

    extensions = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "List of chromium extensions to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    programs.chromium = {
      enable = true;
      inherit (cfg) extraOpts extensions;
    };
  };
}
