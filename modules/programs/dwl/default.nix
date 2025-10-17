{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.programs.dwl;
in {
  config = lib.mkIf cfg.enable {
    programs.dwl = {
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.dwl;
    };
  };
}
