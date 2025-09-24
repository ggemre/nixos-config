{
  pkgs,
  lib,
  ...
}: {
  programs.bash = {
    enable = true;
    vteIntegration = true;
    shellAliases = {
      ls = lib.getExe pkgs.eza;
      cat = lib.getExe pkgs.bat;
      grep = lib.getExe pkgs.ripgrep;
    };
  };
}
