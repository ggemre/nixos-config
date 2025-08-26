# Mostly uses https://github.com/NixOS/nixos-hardware/blob/master/apple/macbook-air/7/default.nix as a reference
{
  lib,
  config,
  pkgs,
  ...
}: {
  boot = {
    kernelParams = [
      "hid_apple.iso_layout=0"
    ];
    blacklistedKernelModules = [
      "bdc_pci"
    ];
  };

  hardware = {
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  services = {
    mbpfan.enable = true;
    fstrim.enable = true;
  };

  environment.systemPackages = [
    pkgs.brightnessctl
  ];
}
