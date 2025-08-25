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
    (selfModulesPath + "/system/apple/macbook-air-7")
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
  };

  users = {
    # mutableUsers = false;
    users."${user}" = {
      home = "/home/${user}";
      description = user;
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPassword = "$y$j9T$SLZhlPDME3Dz/8yrAWV.P0$41gHdK02BiDHeATkV0ANls3KtDJF8aIpmqx1RnFHaX8";
      homeless = true;
    };
  };
}
