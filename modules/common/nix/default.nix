{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    channel.enable = false;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      sandbox = true;
      warn-dirty = false;
      allow-import-from-derivation = false;
      keep-derivations = false;
      use-xdg-base-directories = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://ggemre.cachix.org"
        # "https://nixpkgs-unfree.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ggemre.cachix.org-1:ULcTF3sXFvs42La9WBB+hUOLuI3eFExxQBpRMgOzTdo="
        # "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];

      http-connections = 64;
      max-substitution-jobs = 32;
    };
  };
}
