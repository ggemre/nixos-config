{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.mangowc.settings = {
    bind = [
      # General
      "SUPER, R, reload_config"
      "SUPER, M, quit"
      "SUPER, Q, killclient"

      # Apps
      "SUPER, T, spawn, ${lib.getExe config.programs.foot.package}"
      "SUPER, B, spawn, ${lib.getExe config.programs.helium.package}"

      # Swap focus
      "SUPER, TAB, focusstack, next"
      "SUPER, LEFT, focusdir, left"
      "SUPER, DOWN, focusdir, down"
      "SUPER, UP, focusdir, up"
      "SUPER, RIGHT, focusdir, right"
      "SUPER, H, focusdir, left"
      "SUPER, J, focusdir, down"
      "SUPER, K, focusdir, up"
      "SUPER, L, focusdir, right"
      "SUPER+SHIFT, LEFT, exchange_client, left"
      "SUPER+SHIFT, DOWN, exchange_client, down"
      "SUPER+SHIFT, UP, exchange_client, up"
      "SUPER+SHIFT, RIGHT, exchange_client, right"
      "SUPER+SHIFT, H, exchange_client, left"
      "SUPER+SHIFT, J, exchange_client, down"
      "SUPER+SHIFT, K, exchange_client, up"
      "SUPER+SHIFT, L, exchange_client, right"

      # Window status
      "SUPER, G, toggleglobal"
      "NONE, XF86LaunchA, toggleoverview"
      "SUPER, V, togglefloating"
      "SUPER, A, togglemaximizescreen"
      "SUPER, F, togglefullscreen"
      "SUPER+SHIFT, S, minimized"
      "SUPER, I, restore_minimized"
      "SUPER, S, toggle_scratchpad"

      # Switch tag
      "SUPER, 1, view, 1, 0"
      "SUPER, 2, view, 2, 0"
      "SUPER, 3, view, 3, 0"
      "SUPER, 4, view, 4, 0"
      "SUPER, 5, view, 5, 0"
      "SUPER, 6, view, 6, 0"
      "SUPER, 7, view, 7, 0"
      "SUPER, 8, view, 8, 0"
      "SUPER, 9, view, 9, 0"
      "SUPER+SHIFT, 1, tag, 1, 0"
      "SUPER+SHIFT, 2, tag, 2, 0"
      "SUPER+SHIFT, 3, tag, 3, 0"
      "SUPER+SHIFT, 4, tag, 4, 0"
      "SUPER+SHIFT, 5, tag, 5, 0"
      "SUPER+SHIFT, 6, tag, 6, 0"
      "SUPER+SHIFT, 7, tag, 7, 0"
      "SUPER+SHIFT, 8, tag, 8, 0"
      "SUPER+SHIFT, 9, tag, 9, 0"

      # Resize window
      "SUPER+ALT, LEFT, resizewin, -40, +0"
      "SUPER+ALT, DOWN, resizewin, +0, +40"
      "SUPER+ALT, UP, resizewin, +0, -40"
      "SUPER+ALT, RIGHT, resizewin, +40, +0"
      "SUPER+ALT, H, resizewin, -40, +0"
      "SUPER+ALT, J, resizewin, +0, +40"
      "SUPER+ALT, K, resizewin, +0, -40"
      "SUPER+ALT, L, resizewin, +40, +0"

      # Media controls
      "NONE, XF86AudioLowerVolume, spawn, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-"
      "NONE, XF86AudioRaiseVolume, spawn, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+"
      "NONE, XF86AudioMute, spawn, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "NONE, XF86MonBrightnessDown, spawn, ${lib.getExe pkgs.brightnessctl} -d intel_backlight s 5%-"
      "NONE, XF86MonBrightnessUp, spawn, ${lib.getExe pkgs.brightnessctl} -d intel_backlight s 5%+"
      "NONE, XF86KbdBrightnessDown, spawn, ${lib.getExe pkgs.brightnessctl} -d smc::kbd_backlight s 5%-"
      "NONE, XF86KbdBrightnessUp, spawn, ${lib.getExe pkgs.brightnessctl} -d smc::kbd_backlight s 5%+"
    ];

    mousebind = [
      "SUPER, btn_left, moveresize, curmove"
      "NONE, btn_middle, togglemaximizescreen, 0"
      "SUPER, btn_right, moveresize, curresize"
    ];
  };
}
