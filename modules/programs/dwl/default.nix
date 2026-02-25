{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.dwl;
in {
  config = lib.mkIf cfg.enable {
    programs.dwl = {
      package = pkgs.dwl;
    };
  };
}
