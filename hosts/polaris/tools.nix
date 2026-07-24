{pkgs, ...}: let
  reinstall = pkgs.writeShellScriptBin "reinstall" (builtins.readFile ./reinstall.sh);
in {
  environment.systemPackages = [
    pkgs.disko
    reinstall
  ];
}
