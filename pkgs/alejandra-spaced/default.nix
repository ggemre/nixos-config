{ alejandra }:
alejandra.overrideAttrs (old: {
  patches =
    (old.patches or [])
    ++ [
      ./spaced-elements.patch
    ];
  doCheck = false;
  meta.description = "The Alejandra formatter with spaces around elements.";
})
