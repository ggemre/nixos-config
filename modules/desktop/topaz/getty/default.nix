{
  config,
  lib,
  ...
}: let
  # Find the first "normal" user for autologin.
  normalUsers =
    lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users;
  firstUser =
    lib.head (lib.attrNames normalUsers);
in {
  services.getty = {
    autologinUser = firstUser;
    autologinOnce = true;

    greetingLine = "";
    helpLine = "";
  };

  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec /run/current-system/sw/bin/mango
    fi
  '';

  security.pam.services.getty.enable = true;
}
