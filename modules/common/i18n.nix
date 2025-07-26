# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/i18n.nix
# https://sourceware.org/glibc/wiki/Locales
let
  locale = "en_US.UTF-8";
in {
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_COLLATE = locale;
    LC_CTYPE = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MESSAGES = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };
}
