{pkgs, ...}: {
  theme.name = "catppuccin-mocha";

  programs = {
    direnv.enableBashIntegration = true;
    foot.enableBashIntegration = true;
    firefox.defaultBrowser = true;
  };

  users.users = {
    root.hashedPassword = "!"; # Disable root

    gge = {
      home = "/home/gge";
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      manageHome = true;
      initialHashedPassword = "$y$j9T$uW/lC4wXpVfuOG7CqYtav.$DWSN2WtizNn7gHWE58c1s60zdp61YbZzV4ywAFHqHH2";
    };
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
  system.stateVersion = "26.05";
}
