{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.windowManagers.dwl;
in {
  options.windowManagers.dwl = {
    enable = lib.mkEnableOption "dwl window manager";
    terminal = lib.mkPackageOption pkgs "foot" {};
  };

  config = lib.mkIf cfg.enable {
    programs.dwl = {
      enable = true;
      package =
        (pkgs.dwl.override {
          enableXWayland = true;
          configH = pkgs.replaceVars ./config.h {
            terminal = "${lib.getExe cfg.terminal}";
          };
        }).overrideAttrs (oldAttrs: {
          # buildInputs =
          #   oldAttrs.buildInputs or []
          #   ++ [
          #     pkgs.libdrm
          #     pkgs.fcft
          #   ];
          # patches = oldAttrs.patches or [] ++ [
          #   ./bar-0.7.patch
          # ];
        });
    };
  };
}
