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
    (selfModulesPath + "/system/laptop")
  ];

  theme.name = "catppuccin-mocha";

  programs = {
    foot = {
      enable = true;
      enableBashIntegration = true;
    };

    helix.enable = true;

    hyprland = {
      enable = true;
      terminal = pkgs.foot;
    };

    greetd = {
      enable = true;
      command = pkgs.hyprland;
    };

    bash.enable = true;

    git.enable = true;
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

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0; # mash spacebar to select a previous generation
    };
  };

  # TODO: move to common module
  time.timeZone = "Asia/Phnom_Penh";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.12.43"
  ];

  # Most users should never change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # https://mynixos.com/nixpkgs/option/system.stateVersion
  system.stateVersion = "25.05";
}
