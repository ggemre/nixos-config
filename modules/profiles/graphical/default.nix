{pkgs, ...}: {
  environment = {
    systemPackages = [
      pkgs.brightnessctl
    ];

    variables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
      XDG_SESSION_TYPE = "wayland";

      # Toolkit backends
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # QT specifics
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      # Application specifics
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = 1;
    };
  };
}
