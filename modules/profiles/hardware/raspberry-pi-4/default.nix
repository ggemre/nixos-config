# Cherry-picked options from https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/default.nix
{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd = {
      availableKernelModules = [
        "usb-storage"
        "usbhid"
        "vc4"
        "pcie-brcmstb"
        "reset-raspberrypi"
        "genet"
      ];
      systemd.tpm2.enable = false;
    };
  };

  hardware.deviceTree.filter = "bcm2711-rpi-*.dtb";
  powerManagement.cpuFreqGovernor = "ondemand";
}
