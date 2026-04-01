# Thanks for much inspiration from the HomeManager module.
# https://github.com/nix-community/home-manager/blob/6267895e9898399f0ce2fe79b645e9ee4858aaff/modules/programs/firefox/mkFirefoxModule.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.firefox;

  profileList = lib.attrValues cfg.profiles;

  profiles =
    lib.listToAttrs (
      lib.imap0 (
        i: profile:
          lib.nameValuePair "Profile${toString i}" {
            Name = profile.name;
            Path = profile.name;
            IsRelative = 1;
            Default =
              if profile.isDefault
              then 1
              else 0;
          }
      )
      profileList
    )
    // {
      General = {
        StartWithLastProfile = 1;
      };
    };

  profilesIni = lib.generators.toINI {} profiles;

  userPrefValue = pref:
    builtins.toJSON (
      if lib.isBool pref || lib.isInt pref || lib.isString pref
      then pref
      else builtins.toJSON pref
    );

  mkUserJsFile = prefs:
    lib.concatStrings (
      lib.mapAttrsToList (name: value: ''
        user_pref("${name}", ${userPrefValue value});
      '')
      prefs
    );
in {
  options.programs.firefox = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          {name, ...}: {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Profile name.";
              };

              isDefault = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether this is the default profile.";
              };

              settings = lib.mkOption {
                type = lib.types.attrs;
                default = {};
                description = "Settings to write to user.js";
              };

              userChrome = lib.mkOption {
                type = lib.types.lines;
                default = "";
                description = "User chrome css for Firefox.";
              };

              search = lib.mkOption {
                type = lib.types.submodule (
                  {config, ...}:
                    import ./search.nix {
                      inherit config lib pkgs name;
                    }
                );
              };
            };
          }
        )
      );
    };

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make Firefox the default browser.";
    };
  };

  config = lib.mkIf cfg.enable {
    home = lib.mkMerge (
      [
        {
          ".config/mozilla/firefox/profiles.ini" = lib.mkIf (cfg.profiles != {}) {
            text = profilesIni;
          };
        }
      ]
      ++ lib.flip lib.mapAttrsToList cfg.profiles (
        _: profile:
          lib.mkMerge [
            {
              ".config/mozilla/firefox/${profile.name}/chrome/userChrome.css" = lib.mkIf (profile.userChrome != "") {
                text = profile.userChrome;
              };
              ".config/mozilla/firefox/${profile.name}/user.js" = lib.mkIf (profile.settings != {}) {
                text = mkUserJsFile profile.settings;
              };
              ".config/mozilla/firefox/${profile.name}/search.json.mozlz4" = lib.mkIf (profile.search.engines != []) {
                source = profile.search.file;
              };
            }
          ]
      )
    );

    environment.variables = lib.mkIf cfg.defaultBrowser {
      BROWSER = cfg.package;
    };

    common.mime = lib.mkIf cfg.defaultBrowser {
      browser = "firefox.desktop";
    };
  };
}
