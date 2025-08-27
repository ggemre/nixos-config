# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/networkmanager.nix
_: {
  time.timeZone = "Asia/Phnom_Penh";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
