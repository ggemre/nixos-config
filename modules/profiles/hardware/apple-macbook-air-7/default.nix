# Mostly uses https://github.com/NixOS/nixos-hardware/blob/master/apple/macbook-air/7/default.nix as a reference
{
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

    initrd.kernelModules = [ "kvm-intel" "wl" "i915" ];
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  hardware = {
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.intel-vaapi-driver
        pkgs.intel-ocl

        pkgs.intel-media-driver
        pkgs.intel-compute-runtime
        pkgs.vpl-gpu-rt
      ];
      extraPackages32 = [
        pkgs.driversi686Linux.intel-vaapi-driver
        pkgs.driversi686Linux.intel-media-driver
      ];
    };
  };

  services = {
    mbpfan.enable = true;
    fstrim.enable = true;
  };

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
