{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots_0_20,
  scdoc,
  pkg-config,
  wayland,
  libdrm,
  libxkbcommon,
  pixman,
  wayland-protocols,
  libGL,
  libgbm,
  libxcb,
  libxcb-wm,
  lcms2,
  validatePkgConfig,
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scenefx";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = "scenefx";
    tag = finalAttrs.version;
    hash = "sha256-vUjLG6eubEhJJVa9LPygIcVmNoHwYbSUTJcWEcbxnU4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    validatePkgConfig
    wayland-scanner
  ];

  buildInputs = [
    libdrm
    libGL
    libxkbcommon
    libgbm
    libxcb
    libxcb-wm
    pixman
    wayland
    wayland-protocols
    wlroots_0_20
    lcms2
  ];

  meta = {
    description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = "https://github.com/wlrfx/scenefx";
    changelog = "https://github.com/wlrfx/scenefx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "scenefx";
    pkgConfigModules = [ "scenefx-${lib.versions.majorMinor finalAttrs.version}" ];
    platforms = lib.platforms.all;
  };
})
