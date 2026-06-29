{pkgs, ...}: {
  # TODO: this certainly needs to be slimmed down
  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = [
        pkgs.intel-vaapi-driver
        pkgs.intel-ocl
      ];
    };
  };
}
