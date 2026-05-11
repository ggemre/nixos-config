{
  pkgs,
  selfLib,
  ...
}: {
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
    timeout = 0;
  };

  users.users.dme = {
    home = "/home/dme";
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialHashedPassword = "$y$j9T$p6v03DwnOcmlqc/TlqFsl.$/Lym/5bE8UMRiu7Hyemq.xWEcqKsKA9k2XFkhkwM26D";
    openssh.authorizedKeys.keys = selfLib.pubkeys;
  };

  system.stateVersion = "26.05";
}
