{
  pkgs,
  config,
  lib,
  selfModulesPath,
  ...
}: let
  user = "gge";
in {
  imports = [
    ./hardware.nix
    (selfModulesPath + "/profiles/apple/macbook-air-7")
    (selfModulesPath + "/profiles/laptop")
    (selfModulesPath + "/profiles/graphical")
  ];

  theme.name = "catppuccin-mocha";

  programs = {
    firefox.enable = true;
    foot = {
      enable = true;
      enableBashIntegration = true;
    };
    helix.enable = true;
    hyprland.enable = true;
    bash.enable = true;
    git.enable = true;
  };

  services.displayManager.ly = {
    enable = true;
    waylandCompositor = pkgs.hyprland;
  };

  users = {
    # mutableUsers = false;
    users."${user}" = {
      home = "/home/${user}";
      description = user;
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      homeless = true;
    };
  };

  common.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 25;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0; # mash spacebar to select a previous generation
    };
  };

  # Most users should never change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # https://mynixos.com/nixpkgs/option/system.stateVersion
  system.stateVersion = "25.05";
}
