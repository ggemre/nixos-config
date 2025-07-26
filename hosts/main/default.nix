{
  # self,
  pkgs,
  config,
  lib,
  ...
}: let
  user = "tmp";
in {
  theme = {
    enable = true;
    name = "ayu-dark";
  };

  programs.helix.enable = true;
  windowManagers.hyprland.enable = true;

  users.users."${user}" = {
    home = "/home/${user}";
    description = user;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    hashedPassword = "$y$j9T$wKCnYuCC9cN2XXFyBoXmW.$ERaRxmm237xf.vR8s7TUcZYLwQK/.5MsSPQ2bkrtnB/";
    homeless = true;
  };
  programs.zsh.enable = true;

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel" "wl"];
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  nixpkgs.config.allowUnfree = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/32c4d0ee-ac05-429a-8926-c6a34e1845e7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CAD0-DA2D";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];
}
