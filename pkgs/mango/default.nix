{
  fetchFromGitHub,
  lib,
  libX11,
  libinput,
  libxcb,
  libxkbcommon,
  pcre2,
  pango,
  pixman,
  pkg-config,
  cjson,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  xwayland,
  meson,
  ninja,
  # scenefx,
  callPackage,
  wlroots_0_20,
  libGL,
  libdrm,
  enableXWayland ? true,
}: let
  # TODO: rm once upstream in nixpkgs
  scenefx_0_5 = callPackage ./scenefx.nix {};
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "mango";
    version = "0.15.4";

    src = fetchFromGitHub {
      owner = "mangowm";
      repo = "mango";
      tag = finalAttrs.version;
      hash = "sha256-f5l8fsEqaX37sw4tAXpKQ4D3MOfrSQyulAvmUJgkqh8=";
    };

    mesonFlags = [
      (lib.mesonEnable "xwayland" enableXWayland)
    ];

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      wayland-scanner
    ];

    buildInputs =
      [
        libinput
        libxcb
        libxkbcommon
        pcre2
        pango
        pixman
        cjson
        wayland
        wayland-protocols
        wlroots_0_20
        # scenefx
        scenefx_0_5
        libGL
        libdrm
      ]
      ++ lib.optionals enableXWayland [
        libX11
        libxcb-wm
        xwayland
      ];

    passthru = {
      providedSessions = ["mango"];
    };

    meta = {
      mainProgram = "mango";
      description = "Practical and Powerful wayland compositor (dwm but wayland)";
      homepage = "https://github.com/mangowm/mango";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
    };
  })
