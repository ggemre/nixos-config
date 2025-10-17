{
  config,
  lib,
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
        command = "/run/current-system/sw/bin/dwl";
        user = firstUser;
      };
    };
  };

  security.pam.services.greetd.enable = true;
}
