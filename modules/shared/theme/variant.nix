{
  config,
  lib,
  ...
}: let
  cfg = config.theme;
in {
  programs.dconf.profiles.user.databases = [
    {
      lockAll = false;
      settings = {
        "org/gnome/desktop/interface".color-scheme =
          if cfg.variant == "light"
          then "prefer-light"
          else "prefer-dark";

        "org/freedesktop/appearance".color-scheme =
          if cfg.variant == "light"
          then lib.gvariant.mkUint16 2 # prefer light
          else lib.gvariant.mkUint16 1; # prefer dark
      };
    }
  ];
}
