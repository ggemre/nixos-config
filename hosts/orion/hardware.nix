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
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/mapper/crypt";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-partlabel/NIXOS";

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/BOOT";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
