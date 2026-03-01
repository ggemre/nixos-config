{
  config,
  lib,
  ...
}: {
  imports = [
    ./binds.nix
    ./decorations.nix
  ];

  programs.mangowc = {
    enable = true;

    settings = {
      no_border_when_single = 0;
      focus_on_activate = 1;
      mouse_natural_scrolling = 0;
      disable_trackpad = 0;
      tap_to_click = 0;

      exec-once = [
        (lib.getExe config.programs.waybar.package)
      ];
    };
  };
}
