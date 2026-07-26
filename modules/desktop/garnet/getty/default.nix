{
  config,
  selfLib,
  ...
}: let
  user = selfLib.getPrimaryUser config.users.users;
in {
  services.getty = {
    autologinUser = user;
    autologinOnce = true;
  };

  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec /run/current-system/sw/bin/mango
    fi
  '';

  security.pam.services.getty.enable = true;
}
