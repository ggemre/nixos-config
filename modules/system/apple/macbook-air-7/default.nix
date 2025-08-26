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

    initrd.kernelModules = [ "kvm-intel" "wl" ];
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  hardware = {
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  services = {
    mbpfan.enable = true;
    fstrim.enable = true;
  };

  # TODO: move to common module
  environment.systemPackages = [
    pkgs.brightnessctl
  ];

  nixpkgs.config.permittedInsecurePackages = [ config.boot.kernelPackages.broadcom_sta.name ];

  warnings = [
    ''
      Installing ${config.boot.kernelPackages.broadcom_sta.name}, which is marked as insecure.
      Known issues:
      - CVE-2019-9501: heap buffer overflow, potentially allowing remote code execution by sending specially-crafted WiFi packets
      - CVE-2019-9502: heap buffer overflow, potentially allowing remote code execution by sending specially-crafted WiFi packets
    ''
  ];
}
