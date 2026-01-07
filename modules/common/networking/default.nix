# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/networkmanager.nix
_: {
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
  time.timeZone = "America/New_York";

  networking = {
    nameservers = [
      # Cloudflare
      "1.1.1.1"
      "1.0.0.1"
    ];

    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        backend = "iwd";
        macAddress = "random";
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
