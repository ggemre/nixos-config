{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.programs.zen;
in {
  options.programs.zen = {
    enable = lib.mkEnableOption "Whether to enable the Zen browser.";

    version = lib.mkOption {
      type = lib.types.enum [ "beta" "twilight" "twilight-official" ];
      default = "beta";
      description = "The version of Zen to install";
    };

    policies = lib.mkOption {
      type = (pkgs.formats.json {}).type;
      default = {};
      description = "Policies to pass to Zen.";
    };

    userChrome = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.lines
        lib.types.path
      ];
      default = "";
      description = "User chrome css for Zen.";
    };

    searchJsonArchive = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Search engines settings in the `.mozlz4` format.
        To generate this file, you can:
        1. Configure the search engines imperatively and then copy
           ~/.zen/<profile>/search.json.mozlz4 to your config.
        2. Write your own `search.json` file (see templates online) and then use
           `mozlz4a` to compress it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (
        pkgs.wrapFirefox (self.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped.override {
          # Seems like zen uses relative (to the original binary) path to the policies.json file
          # and ignores the overrides by pkgs.wrapFirefox
          name = cfg.version;
          inherit (cfg) policies;
        }) {}
      )
    ];

    homeless = {
      ".zen/profiles.ini".text = ''
        [Profile0]
        Name=main
        IsRelative=1
        Path=main
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      ".zen/main/chrome/userChrome.css" = lib.mkIf (cfg.userChrome != "") (
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
      ".zen/main/search.json.mozlz4" = lib.mkIf (cfg.searchJsonArchive != null) {
        source = cfg.searchJsonArchive;
      };
    };
  };
}
