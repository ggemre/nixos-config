# Much of the logic of this file is derived from what HomeManager already figured out.
# https://github.com/nix-community/home-manager/blob/4aeef1941f862fe3a70d1b8264b4e289358c2325/modules/programs/firefox/profiles/search.nix#L186
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.firefox.search;

  toId = name:
    builtins.replaceStrings [ " " ] [ "-" ] (lib.toLower name);

  formattedEnginesList =
    lib.lists.imap0 (i: e: {
      id = toId e.name;
      _name = e.name;
      _loadPath = "[user]";
      _metaData = {
        alias = e.alias;
        order = i + 1;
      };
      _urls = [
        {
          template = e.url;
        }
      ];
    })
    cfg.engines;

  settings = {
    version = 13;
    engines = formattedEnginesList;

    metaData = lib.optionalAttrs (cfg.default != null) {
      defaultEngineId = toId cfg.default;
      defaultEngineIdHash = "@hash@";
    };
  };

  profile = "main";

  # I am the user and I consent to what I'm doing.
  disclaimer =
    "By modifying this file, I agree that I am doing so "
    + "only within Firefox itself, using official, user-driven search "
    + "engine selection processes, and in a way which does not circumvent "
    + "user consent. I acknowledge that any attempt to change this file "
    + "from outside of Firefox is a malicious act, and will be responded "
    + "to accordingly.";

  defaultPayload =
    if cfg.default != null
    then profile + (toId cfg.default) + disclaimer
    else null;

  file =
    pkgs.runCommand "search.json.mozlz4" {
      nativeBuildInputs = [
        pkgs.mozlz4a
        pkgs.openssl
      ];
      json = builtins.toJSON settings;
      inherit defaultPayload;
    } ''
      if [[ -n $defaultPayload ]]; then
        export hash=$(echo -n "$defaultPayload" | openssl dgst -sha256 -binary | base64)
        mozlz4a <(substituteStream json search.json.in --subst-var hash) "$out"
      else
        mozlz4a <(echo "$json") "$out"
      fi
    '';
in {
  options.programs.firefox.search = {
    default = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The default search engine";
    };

    engines = lib.mkOption {
      # type = lib.types.listOf lib.types.attrs;
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          alias = lib.mkOption { type = lib.types.str; };
          url = lib.mkOption { type = lib.types.str; };
        };
      });
      default = [];
      description = "List of search engine configurations.";
      example = lib.literalExpression ''
        [
          {
            name = "Nix Package";
            url = "https://search.nixos.org/packages?type=packages?query={searchTerms}";
            alias = "@np";
          }
        ]
      '';
    };

    file = lib.mkOption {
      type = lib.types.path;
      default = file;
      readOnly = true;
      description = "Auto-generated search.json.mozlz4 file.";
    };
  };

  config = lib.mkIf (config.programs.firefox.enable && (cfg.engines != [])) {
    home.".mozilla/firefox/main/search.json.mozlz4".source = cfg.file;
  };
}
