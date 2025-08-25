# Mostly uses https://github.com/NixOS/nixos-hardware/blob/master/apple/macbook-air/7/default.nix as a reference
{
  lib,
  config,
  ...
}: {
  # boot = {
  #   kernelParams = [
  #     "hid_apple.iso_layout=0"
  #   ];
  #   blacklistedKernelModules = [
  #     "bdc_pci"
  #   ];
  # };

  # hardware = {
  #   facetimehd.enable = true;
  #   cpu.intel.updateMicrocode = true;
  # };

  # services = {
  #   mbpfan.enable = true;
  #   fstrim.enable = true;
  # };

  warnings = [
    ''
      Not one setting in this module works with the current linux kernel version and I'm not willing to downgrade.
      For now, functionality is disabled until something changes, (doesn't work with the nixos-hardware module either).
    ''
  ];
}
