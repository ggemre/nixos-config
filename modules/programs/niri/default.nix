{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.programs.niri;
in {
  options.programs.niri = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to the niri configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
    };

    homeless.".config/niri/config.kdl".text = self.lib.generators.kdl cfg.settings;
  };
}
