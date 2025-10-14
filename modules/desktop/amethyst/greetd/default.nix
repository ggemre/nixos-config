{
  config,
  lib,
  pkgs,
  ...
}: let
  # Find the first "normal" user for autologin.
  # This is no problem because we only use autologin on our laptops which have just one user.
  normalUsers =
    lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users;
  firstUser =
    lib.head (lib.attrNames normalUsers);
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.uwsm} start -F /run/current-system/sw/bin/Hyprland";
        user = firstUser;
      };
    };
  };

  security.pam.services.greetd.enable = true;
}
