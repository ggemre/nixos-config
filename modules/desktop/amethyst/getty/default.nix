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
  services.getty = {
    autologinUser = firstUser;
    autologinOnce = true;
  };

  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec /run/current-system/sw/bin/start-hyprland
    fi
  '';

  security.pam.services.getty.enable = true;
}
