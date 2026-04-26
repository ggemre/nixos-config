{pkgs, ...}: let
  # FIXME: impure hack to get Ethernet working again.
  # The rpi kernel was removed from nixpkgs, and the recommended alternative, nixos-hardware, has no binary cache.
  # No biggie, I hardly use my pi so no need to add a flake input for now.
  # TODO: figure out mainline kernel with working Ethernet or wait for nixos-hardware cache.
  rpiPkgs = (builtins.getFlake "github:nvmd/nixos-raspberrypi/0fca4e50b506abfc5915f990f07868e717477d4e").packages.${pkgs.stdenv.hostPlatform.system};
in {
  boot = {
    kernelPackages = rpiPkgs.linuxPackages_rpi4;
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

  nix.settings = {
    substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
}
