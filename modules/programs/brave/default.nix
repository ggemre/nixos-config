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
      pkgs.brave
    ];

    programs.chromium = {
      enable = true;
      inherit (cfg) extraOpts extensions;
    };
  };
}
