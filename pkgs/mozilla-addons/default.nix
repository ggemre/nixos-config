{
  lib,
  stdenv,
  fetchurl,
}: let
  buildMozillaXpiAddon = {
    pname,
    version,
    addonId,
    url,
    sha256,
    meta ? {},
  }:
  # Thank you @rycee for the inspiration and function for packaging xpi files
  # https://github.com/nix-community/nur-combined/blob/19e3ae8433ef84ff0f6ac29185ad0081c0726516/repos/rycee/lib/mozilla.nix#L21-L40
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {
        inherit url sha256;
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
in {
  ublock-origin = buildMozillaXpiAddon {
    pname = "ublock-origin";
    version = "1.73.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4940584/ublock_origin-1.73.0.xpi";
    sha256 = "bccc51a773150af4af6e1fd62c7bfdeb7238b79ff2381b998fa9f2e38f64786a";
    meta = {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = lib.licenses.gpl3;
    };
  };
}
