{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.utils;
in {
  options.programs.utils = {
    enable = lib.mkEnableOption "Whether to install various useful cli utilities.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.btop
      pkgs.ripgrep
    ];
  };
}
