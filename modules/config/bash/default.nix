{
  lib,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    vteIntegration = true;
    shellAliases = {
      ls = lib.getExe pkgs.eza;
    };
  };
}
