{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowBroken = false;
    };
    overlays = [
      (import ../../pkgs)
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.privatevoid.net"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      ];
    };
  };
}
