{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.dwl;
in {
  options.programs.dwl = {
    terminal = lib.mkPackageOption pkgs "foot" {};
  };

  config = {
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
