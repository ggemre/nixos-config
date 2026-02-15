{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      "$mod, T, exec, ${lib.getExe config.programs.foot.package}"
      "$mod, B, exec, ${lib.getExe config.programs.firefox.package}"
      "$mod, SPACE, exec, ${lib.getExe config.programs.hyprlauncher.package}"
      "$mod, Q, killactive"
      "$mod SHIFT, M, exit"
      "$mod, M, exec, ${lib.getExe config.programs.hyprlock.package}"
      "$mod, V, togglefloating"
      "$mod, P, pseudo, # dwindle"
      "$mod, semicolon, togglesplit,"
      "$mod, S, togglespecialworkspace"
      "$mod, F, fullscreen, 0"
      "$mod SHIFT, S, movetoworkspace, special"
      "$mod, G, exec, ${lib.getExe pkgs.grim}"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # Move focus with mainMod + arrow/hx keys
      "$mod, left, movefocus, l"
      "$mod, down, movefocus, d"
      "$mod, up, movefocus, u"
      "$mod, right, movefocus, r"
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      # Swap window in given direction
      "$mod SHIFT, left, swapwindow, l"
      "$mod SHIFT, down, swapwindow, d"
      "$mod SHIFT, up, swapwindow, u"
      "$mod SHIFT, right, swapwindow, r"
      "$mod SHIFT, H, swapwindow, l"
      "$mod SHIFT, J, swapwindow, d"
      "$mod SHIFT, K, swapwindow, u"
      "$mod SHIFT, L, swapwindow, r"

      # Switch workspaces with mainMod + [0-9]
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Scroll through existing workspaces with mainMod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Resize windows
      "$mod ALT, left, resizeactive, -40 0"
      "$mod ALT, down, resizeactive, 0 40"
      "$mod ALT, up, resizeactive, 0 -40"
      "$mod ALT, right, resizeactive, 40 0"
      "$mod ALT, H, resizeactive, -40 0"
      "$mod ALT, J, resizeactive, 0 40"
      "$mod ALT, K, resizeactive, 0 -40"
      "$mod ALT, L, resizeactive, 40 0"
    ];

    binde = [
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+"
      ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} -d intel_backlight s 5%-"
      ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} -d intel_backlight s 5%+"
      ", XF86KbdBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} -d smc::kbd_backlight s 5%-"
      ", XF86KbdBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} -d smc::kbd_backlight s 5%+"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
