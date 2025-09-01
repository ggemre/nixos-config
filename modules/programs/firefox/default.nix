{
  config,
  lib,
  ...
}: let
  cfg = config.programs.firefox;
in {
  options.programs.firefox = {
    userChrome = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.lines
        lib.types.path
      ];
      default = "";
      description = "User chrome css for Firefox.";
    };
  };

  config = lib.mkIf cfg.enable {
    homeless = {
      ".mozilla/firefox/profiles.ini".text = ''
        [Profile0]
        Name=main
        IsRelative=1
        Path=main
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      ".mozilla/firefox/main/chrome/userChrome.css" = lib.mkIf (cfg.userChrome != "") (
        let
          key =
            if builtins.isString cfg.userChrome
            then "text"
            else "source";
        in {
          "${key}" = cfg.userChrome;
        }
      );

      # The only non-IFD way to get custom search engines. Docs to come.
      ".mozilla/firefox/main/search.json.mozlz4".source = ./search.json.mozlz4;
    };
  };
}
