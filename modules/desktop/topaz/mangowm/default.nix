{
  auxpkgs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./decorations.nix
  ];

  programs.mangowm = {
    enable = true;
    package = auxpkgs.mangowm;

    settings = {
      no_border_when_single = false;
      focus_on_activate = true;

      mouse_natural_scrolling = false;
      disable_trackpad = false;
      tap_to_click = false;
      click_method = 2; # 1 finger left click, 2 finger right click

      scroller_prefer_overspread = true;
      edge_scroller_pointer_focus = false;

      exec-once = [
        (lib.getExe config.programs.waybar.package)
        (lib.getExe config.services.hypridle.package)
        "${lib.getExe pkgs.wbg} --stretch $(find $XDG_PICTURES_DIR/wallpapers -type f | shuf -n 1)"
      ];
    };
  };
}
