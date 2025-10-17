{pkgs}:
(pkgs.dwl.override {
  enableXWayland = true;
  configH = ./config.h;
}).overrideAttrs (old: {
  buildInputs =
    (old.buildInputs or [])
    ++ [
      pkgs.libdrm
      pkgs.fcft
      pkgs.pixman
    ];
  patches =
    (old.patches or [])
    ++ [
      ./bar.patch
    ];
})
