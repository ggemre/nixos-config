{pkgs, ...}: let
  user = "gge";
in {
  theme.name = "rose-pine-moon";

  programs = {
    foot.enableBashIntegration = true;
    direnv.enableBashIntegration = true;
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

  graphical.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 25;
  };

  common.userDirs = {
    documents = "$HOME/docs";
    download = "$HOME/tmp";
    pictures = "$HOME/media/pictures";
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
