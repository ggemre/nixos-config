{pkgs, ...}: {
  theme.name = "catppuccin-mocha";

  programs = {
    foot.enableBashIntegration = true;
    firefox.defaultBrowser = true;
  };

  users.users.dme = {
    home = "/home/dme";
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    manageHome = true;
    initialHashedPassword = "$y$j9T$uu7ydGJuLw1v5CDtoO7/41$sedSvbag.VzjLdRAq.F4uN6ZIhDuOOW8bUMDgKHiFmB";
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
    };
    timeout = 0; # mash spacebar to select a previous generation
  };

  # Most users should never change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # https://mynixos.com/nixpkgs/option/system.stateVersion
  system.stateVersion = "26.11";
}
