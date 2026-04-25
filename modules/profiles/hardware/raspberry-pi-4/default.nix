# Cherry-picked options from https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/default.nix
_: {
  imports = [
    ./sd-image.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "usb-storage"
        "usbhid"
        "vc4"
        "pcie-brcmstb"
        "reset-raspberrypi"
        "genet"
      ];
      # systemd.tpm2.enable = false;
    };
  };

  # FIXME: what makes Ethernet work?
  # hardware.deviceTree.filter = "bcm2711-rpi-*.dtb";
  hardware.enableAllHardware = true;
  hardware.enableAllFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
