# Cherry-picked options from https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/default.nix
_: {
  imports = [
    ./uefi-image.nix
  ];

  boot.initrd = {
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

  powerManagement.cpuFreqGovernor = "ondemand";
}
