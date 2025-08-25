# Mostly uses https://github.com/NixOS/nixos-hardware/blob/master/apple/macbook-air/7/default.nix as a reference
{lib, ...}: {
  boot = {
    kernelParams = [
      "hid_apple.iso_layout=0"
    ];
    blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
      "ath3k"
    ];
  };

  hardware = {
    facetimehd.enable = lib.mkDefault (config.nixpkgs.config.allowUnfree or false);
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  services = {
    mbpfan.enable = lib.mkDefault true;
    fstrim.enable = lib.mkDefault true;
  };
}
