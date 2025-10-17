{pkgs}:
pkgs.dwl.override {
  enableXWayland = true;
  configH = ./config.h;
}

