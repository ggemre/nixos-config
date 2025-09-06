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

    searchJsonArchive = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Search engines settings in the `.mozlz4` format.
        To generate this file, you can:
        1. Configure the search engines imperatively and then copy
           ~/.mozilla/firefox/<profile>/search.json.mozlz4 to your config.
        2. Write your own `search.json` file (see templates online) and then use
           `mozlz4a` to compress it.
      '';
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

      # The only non-IFD way to get custom search engines.
      ".mozilla/firefox/main/search.json.mozlz4" = lib.mkIf (cfg.searchJsonArchive != null) {
        source = cfg.searchJsonArchive;
      };
    };
  };
}
