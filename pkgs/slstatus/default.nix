{pkgs}: (pkgs.slstatus.override {
  conf = ./config.h;
})
