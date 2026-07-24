# Some of my hardware requires broadcom drivers which are not included by default
# TODO: remove module when deemed unnecessary
{config, ...}: {
  nixpkgs.config.allowUnfree = true;
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  nixpkgs.config.permittedInsecurePackages = [ config.boot.kernelPackages.broadcom_sta.name ];
}
