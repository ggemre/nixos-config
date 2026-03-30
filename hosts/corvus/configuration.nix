{pkgs, ...}: let
  user = "dme";
in {
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
    timeout = 0;
  };

  users.users."${user}" = {
    home = "/home/${user}";
    description = user;
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    manageHome = true;
  };

  system.stateVersion = "23.11";
}
