# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/networkmanager.nix
_: {
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
  time.timeZone = "America/New_York";

  networking = {
    dhcpcd.enable = true;
    useDHCP = false;

    networkmanager = {
      enable = true;
      wifi.powersave = false;
      insertNameservers = [
        # Cloudflare
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };
}
