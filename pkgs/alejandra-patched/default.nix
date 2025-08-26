{pkgs}:
pkgs.alejandra.overrideAttrs (old: {
  patches =
    (old.patches or [])
    ++ [
      ./spaced-elements.patch
      ./no-ads.patch
    ];
  doCheck = false;
  meta.description = "Custom Alejandra with spaces around elements and 0 ads.";
})
