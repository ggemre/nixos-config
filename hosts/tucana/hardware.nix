{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/ROOT";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-partlabel/SWAP"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
