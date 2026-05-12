# Cherry-picked options from https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/default.nix
_: {
  boot.initrd = {
    availableKernelModules = [
      "usb-storage"
      "usbhid"
      "vc4"
      "pcie-brcmstb"
      "reset-raspberrypi"
    ];
    systemd.tpm2.enable = false;
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
