{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  alsa-lib,
  e2fsprogs,
  fontconfig,
  gmp,
  harfbuzz,
  libdrm,
  libGL,
  libgpg-error,
  libthai,
  nss,
  p11-kit,
  zlib,
  fribidi,
  xorg,
  postgresql,
  unixODBC,
}: let
  pkgs23-11 =
    import (fetchTarball {
      # 23.11 still ships a curl with CURL_GNUTLS_3
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
      sha256 = "sha256-zwVvxrdIzralnSbcpghA92tWu2DV2lwv89xZc8MTrbg=";
    }) {
      system = stdenv.hostPlatform.system;
    };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "webull-desktop";
    version = "9.3.0";

    src = fetchurl {
      url = "https://u1sweb.webullfintech.com/us/Webull%20Desktop_9.3.0_9100000072_global_x64signed.deb";
      hash = "sha256-7xP4Q8eDMj2Pj/Zksr2gROJR1fPd4lz2zPpcAcu2o80=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeBinaryWrapper
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      alsa-lib
      e2fsprogs
      fontconfig
      gmp
      harfbuzz
      libdrm
      libGL
      libgpg-error
      libthai
      nss
      p11-kit
      zlib

      fribidi
      xorg.libXrandr
      postgresql.lib
      unixODBC
      pkgs23-11.curlWithGnuTls
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out

      mkdir $out/bin
      ln -s $out/usr/local/WebullDesktop/WebullDesktop $out/bin/webull-desktop

      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/platforms
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/bearer
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/iconengines
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/imageformats
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforminputcontexts
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforms
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/position
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/printsupport
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/sqldrivers
      addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/xcbglintegrations

      wrapProgram $out/usr/local/WebullDesktop/WebullDesktop \
        --set QT_PLUGIN_PATH \
        "$out/usr/local/WebullDesktop/platforms:\
        $out/usr/local/WebullDesktop/plugins/bearer:\
        $out/usr/local/WebullDesktop/plugins/iconengines:\
        $out/usr/local/WebullDesktop/plugins/imageformats:\
        $out/usr/local/WebullDesktop/plugins/platforminputcontexts:\
        $out/usr/local/WebullDesktop/plugins/platforms:\
        $out/usr/local/WebullDesktop/plugins/position:\
        $out/usr/local/WebullDesktop/plugins/printsupport:\
        $out/usr/local/WebullDesktop/plugins/sqldrivers:\
        $out/usr/local/WebullDesktop/plugins/xcbglintegrations"

      runHook postInstall
    '';

    meta = {
      description = "Webull desktop trading application";
      homepage = "https://www.webull.com/trading-platforms/desktop-app";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "webull-desktop";
    };
  })
