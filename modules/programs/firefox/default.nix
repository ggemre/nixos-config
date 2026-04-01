{
  config,
  lib,
  ...
}: let
  cfg = config.programs.firefox;
in {
  imports = [
    ./search.nix
    ./settings.nix
  ];

  options.programs.firefox = {
    userChrome = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.lines
        lib.types.path
      ];
      default = "";
      description = "User chrome css for Firefox.";
    };

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make Firefox the default browser.";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      ".config/mozilla/firefox/profiles.ini".text = ''
        [Profile0]
        Name=main
        IsRelative=1
        Path=main
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      ".config/mozilla/firefox/main/chrome/userChrome.css" = lib.mkIf (cfg.userChrome != "") (
        let
          key =
            if builtins.isString cfg.userChrome
            then "text"
            else "source";
        in {
          "${key}" = cfg.userChrome;
        }
      );
    };

    environment.variables = lib.mkIf cfg.defaultBrowser {
      BROWSER = cfg.package;
    };

    common.mime = lib.mkIf cfg.defaultBrowser {
      browser = "firefox.desktop";
    };
  };
}
