{
  config,
  lib,
  nurPkgs,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./decorations.nix
  ];

  programs.mangowm = {
    enable = true;
    package = nurPkgs.ggemre.mangowm;

    settings = {
      no_border_when_single = false;
      focus_on_activate = true;
      mouse_natural_scrolling = false;
      disable_trackpad = false;
      tap_to_click = false;
      scroller_prefer_overspread = true;

      exec-once = [
        (lib.getExe config.programs.waybar.package)
        (lib.getExe config.services.hypridle.package)
        "${lib.getExe pkgs.wbg} --stretch $(find $XDG_PICTURES_DIR/wallpapers -type f | shuf -n 1)"
      ];
    };
  };
}
