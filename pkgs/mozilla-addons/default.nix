{
  lib,
  stdenv,
  fetchurl,
}: let
  addons = builtins.fromJSON (builtins.readFile ./addons.json);

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
