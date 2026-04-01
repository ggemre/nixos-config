# Much of the logic of this file is derived from what HomeManager already figured out.
# https://github.com/nix-community/home-manager/blob/4aeef1941f862fe3a70d1b8264b4e289358c2325/modules/programs/firefox/profiles/search.nix#L186
{
  config,
  lib,
  name,
  pkgs,
  ...
}: let
  toId = name:
    builtins.replaceStrings [ " " ] [ "-" ] (lib.toLower name);

  formattedEnginesList =
    lib.lists.imap0 (i: e: {
      id = toId e.name;
      _name = e.name;
      _loadPath = "[user]";
      _metaData = {
        inherit (e) alias;
        order = i + 1;
      };
      _urls = [
        {
          template = e.url;
        }
      ];
    })
    config.engines;

  settings = {
    version = 13;
    engines = formattedEnginesList;

    metaData = lib.optionalAttrs (config.default != null) {
      defaultEngineId = toId config.default;
      defaultEngineIdHash = "@hash@";
    };
  };

  # I am the user and I consent to what I'm doing.
  disclaimer =
    "By modifying this file, I agree that I am doing so "
    + "only within Firefox itself, using official, user-driven search "
    + "engine selection processes, and in a way which does not circumvent "
    + "user consent. I acknowledge that any attempt to change this file "
    + "from outside of Firefox is a malicious act, and will be responded "
    + "to accordingly.";

  defaultPayload =
    if config.default != null
    then name + (toId config.default) + disclaimer
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
  options = {
    default = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The default search engine";
    };

    engines = lib.mkOption {
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
      internal = true;
      readOnly = true;
    };
  };
}
