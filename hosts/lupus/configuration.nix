{pkgs, ...}: {
  users.users.nkl = {
    home = "/home/nkl";
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialHashedPassword = "$y$j9T$p6v03DwnOcmlqc/TlqFsl.$/Lym/5bE8UMRiu7Hyemq.xWEcqKsKA9k2XFkhkwM26D";
  };

  environment.systemPackages = [
    pkgs.cowsay
  ];

  system.stateVersion = "26.05";
}
