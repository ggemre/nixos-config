{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cjson,
  fcft,
  tllist,
  pixman,
  cairo,
  pango,
  libpulseaudio,
  systemd,
  gdk-pixbuf,
  alsa-lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mangobar";
  version = builtins.substring 0 7 finalAttrs.src.rev;

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mangobar";
    rev = "55ebf575075ce3497177b68d58af89143da2bc65";
    hash = "sha256-wzQELB0I3YGcSAM7YE4qkbg241lWOkr299GFQSDVQIE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cjson
    fcft
    tllist
    pixman
    cairo
    pango
    libpulseaudio
    systemd
    gdk-pixbuf
    alsa-lib
  ];

  meta = {
    description = "Wayland status bar for mangowm, built on wlr-layer-shell";
    homepage = "https://github.com/mangowm/mangobar";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "mangobar";
  };
})
