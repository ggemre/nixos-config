# This file should not be changed, rather `addons.json` is the source of truth.
{
  lib,
  stdenv,
  fetchurl,
}: let
  addons = builtins.fromJSON (builtins.readFile ./addons.json);

  # Thank you @rycee for the inspiration and function for packaging xpi files
  # https://github.com/nix-community/nur-combined/blob/19e3ae8433ef84ff0f6ac29185ad0081c0726516/repos/rycee/lib/mozilla.nix#L21-L40
  buildMozillaXpiAddon = {
    pname,
    addonId,
    version,
    url,
    hash,
    meta ? {},
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {
        inherit url hash;
      };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {
        inherit addonId;
      };

      buildCommand = ''
        mkdir -p "$out/share/mozilla/extensions"

        install -v -m644 "$src" \
          "$out/share/mozilla/extensions/${addonId}.xpi"
      '';
    };
in
  lib.mapAttrs
  (
    pname: addon:
      buildMozillaXpiAddon {
        inherit pname;
        inherit
          (addon)
          addonId
          version
          url
          hash
          meta
          ;
      }
  )
  addons
