# Modified version of https://github.com/0xc000022070/zen-browser-flake
# Credit goes to @0xc000022070, thanks!
{
  pkgs,
  name ? "beta", # beta or twilight
  policies ? {},
  lib,
  stdenv,
  config,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libXtst,
  libva,
  libGL,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  undmg,
  writeText,
  fetchurl,
  fetchzip,
  makeDesktopItem,
  copyDesktopItems,
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
}: let
  variant = (builtins.fromJSON (builtins.readFile ./sources.json)).${name}.${pkgs.stdenv.hostPlatform.system};

  applicationName = "Zen Browser (${name})";
  binaryName = "zen-${name}";
  libName = "zen-bin-${variant.version}";

  mozillaPlatforms = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
  };

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  pname = "zen-${name}-bin-unwrapped";
in
  pkgs.stdenv.mkDerivation {
    inherit pname;
    inherit (variant) version;

    src = fetchzip {
      inherit (variant) url;
      hash = variant.sha256;
    };

    desktopItems = [
      (makeDesktopItem {
        name = binaryName;
        desktopName = "Zen Browser";
        exec = "${binaryName} %u";
        icon = binaryName;
        type = "Application";
        mimeTypes = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "application/x-xpinstall"
          "application/pdf"
          "application/json"
        ];
        startupWMClass = binaryName;
        categories = [ "Network" "WebBrowser" ];
        startupNotify = true;
        terminal = false;
        keywords = [ "Internet" "WWW" "Browser" "Web" "Explorer" ];
        extraConfig.X-MultipleArgs = "false";

        actions = {
          new-windows = {
            name = "Open a New Window";
            exec = "${binaryName} %u";
          };
          new-private-window = {
            name = "Open a New Private Window";
            exec = "${binaryName} --private-window %u";
          };
          profilemanager = {
            name = "Open the Profile Manager";
            exec = "${binaryName} --ProfileManager %u";
          };
        };
      })
    ];

    nativeBuildInputs = [
      wrapGAppsHook3
      autoPatchelfHook
      patchelfUnstable
      copyDesktopItems
    ];

    buildInputs = [
      gtk3
      adwaita-icon-theme
      alsa-lib
      dbus-glib
      libXtst
    ];

    runtimeDependencies = [
      curl
      libva.out
      pciutils
      libGL
    ];

    appendRunpaths = [
      "${libGL}/lib"
      "${pipewire}/lib"
    ];

    # Firefox uses "relrhack" to manually process relocations from a fixed offset
    patchelfFlags = [ "--no-clobber-old-sections" ];

    preFixup = ''
      gappsWrapperArgs+=(
        --add-flags "--name=''${MOZ_APP_LAUNCHER:-${binaryName}}"
      )
    '';

    installPhase = ''
      runHook preInstall

      # Linux tarball installation
      mkdir -p "$prefix/lib/${libName}"
      cp -r "$src"/* "$prefix/lib/${libName}"

      mkdir -p "$out/bin"
      ln -s "$prefix/lib/${libName}/zen" "$out/bin/${binaryName}"
      ln -s "$out/bin/${binaryName}" "$out/bin/zen"

      mkdir -p "$out/lib/${libName}/distribution"
      ln -s ${policiesJson} "$out/lib/${libName}/distribution/policies.json"

      install -D $src/browser/chrome/icons/default/default16.png $out/share/icons/hicolor/16x16/apps/zen-${name}.png
      install -D $src/browser/chrome/icons/default/default32.png $out/share/icons/hicolor/32x32/apps/zen-${name}.png
      install -D $src/browser/chrome/icons/default/default48.png $out/share/icons/hicolor/48x48/apps/zen-${name}.png
      install -D $src/browser/chrome/icons/default/default64.png $out/share/icons/hicolor/64x64/apps/zen-${name}.png
      install -D $src/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen-${name}.png

      runHook postInstall
    '';

    passthru = {
      inherit applicationName binaryName libName;
      ffmpegSupport = true;
      gssSupport = true;
      gtk3 = gtk3;
    };

    meta = {
      description = "Experience tranquillity while browsing the web without people tracking you!";
      homepage = "https://zen-browser.app";
      downloadPage = "https://zen-browser.app/download/";
      changelog = "https://github.com/zen-browser/desktop/releases";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = builtins.attrNames mozillaPlatforms;
      hydraPlatforms = [];
      mainProgram = binaryName;
      desktopFileName = "${binaryName}.desktop";
    };
  }
