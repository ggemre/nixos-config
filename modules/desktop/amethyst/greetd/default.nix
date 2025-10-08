{
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.uwsm} start -F /run/current-system/sw/bin/Hyprland";
        user = "gge"; # TODO: don't hardcode user
      };
    };
  };

  security.pam.services.greetd.enable = true;
}
