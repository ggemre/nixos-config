{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.services.desktopManager.cosmic;
  genConfigTree = import ./gen-config-tree.nix { inherit lib self; };
in {
  options.services.desktopManager.cosmic = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to write to the Cosmic DE configuration files.";
    };
  };

  config = lib.mkIf cfg.enable {
    home = genConfigTree cfg.settings;
  };
}
