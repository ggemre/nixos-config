{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./decorations.nix
  ];

  programs.mango = {
    enable = true;

    settings = {
      no_border_when_single = false;
      focus_on_activate = true;
      xwayland_persistence = false;

      enable_hotarea = false;
      mouse_natural_scrolling = false;
      disable_trackpad = false;
      tap_to_click = false;
      click_method = 2; # 1 finger left click, 2 finger right click
      cursor_hide_timeout = 60; # 60s

      scroller_prefer_overspread = true;
      edge_scroller_pointer_focus = false;

      windowrule = [
        "isterm:1,appid:foot"
      ];

      circle_layout = "fair,scroller,tile";
      tagrule = [
        "id:1,layout_name:fair"
        "id:2,layout_name:fair"
        "id:3,layout_name:fair"
        "id:4,layout_name:fair"
        "id:5,layout_name:fair"
        "id:6,layout_name:fair"
        "id:7,layout_name:fair"
        "id:8,layout_name:fair"
        "id:9,layout_name:fair"
      ];

      exec-once = [
        (lib.getExe config.services.swayidle.package)
        (lib.getExe pkgs.wayland-pipewire-idle-inhibit)
      ];
    };
  };
}
