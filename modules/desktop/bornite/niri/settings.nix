{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.niri.settings = {
    input = {
      touchpad = {
        tap = true;
        natural-scroll = false;
      };
    };

    layout = {
      gaps = 0;
      center-focused-column = "never";
      # preset-column-widths = [
      #   { proportion = 0.33333; }
      #   { proportion = 0.5; }
      #   { proportion = 0.66667; }
      # ];
      default-column-width = { proportion = 0.5; };
      focus-ring = {
        width = 4;
        active-color = "${config.theme.colorsWithHashtag.base0D}";
        inactive-color = "${config.theme.colorsWithHashtag.base03}";
      };
      border = {
        off = true;
        width = 4;
        active-color = "${config.theme.colorsWithHashtag.base0D}";
        inactive-color = "${config.theme.colorsWithHashtag.base03}";
        urgent-color = "${config.theme.colorsWithHashtag.base0A}";
      };
      shadow = {
        on = false;
      };
    };

    spawn-at-startup = "waybar";

    hotkey-overlay = {};

    # screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    binds = {
      "Mod+Shift+Slash" = { show-hotkey-overlay = true; };
      "Mod+T" = {
        _props = { hotkey-overlay-title = "Open a Terminal: foot"; };
        spawn = "${lib.getExe pkgs.foot}";
      };
      # "Super+Alt+L" = {
      #   _props = { hotkey-overlay-title = "Lock the Screen: swaylock"; };
      #   spawn = "swaylock";
      # };
      # "Super+Alt+S" = {
      #   _props = {
      #     allow-when-locked = true;
      #     hotkey-overlay-title = null;
      #   };
      #   spawn-sh = "pkill orca || exec orca";
      # };
      "XF86AudioRaiseVolume" = {
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
      };
      "XF86AudioLowerVolume" = {
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
      };
      "XF86AudioMute" = {
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      "XF86AudioMicMute" = {
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
      "XF86MonBrightnessUp" = {
        _props = { allow-when-locked = true; };
        spawn = [ "${lib.getExe pkgs.brightnessctl}" "--class=backlight" "set" "+10%" ];
      };
      "XF86MonBrightnessDown" = {
        _props = { allow-when-locked = true; };
        spawn = [ "${lib.getExe pkgs.brightnessctl}" "--class=backlight" "set" "10%-" ];
      };
      "Mod+O" = {
        _props = { repeat = false; };
        toggle-overview = true;
      };
      "Mod+Q" = {
        _props = { repeat = false; };
        close-window = true;
      };
      "Mod+Left" = { focus-column-left = true; };
      "Mod+Down" = { focus-window-down = true; };
      "Mod+Up" = { focus-window-up = true; };
      "Mod+Right" = { focus-column-right = true; };
      "Mod+H" = { focus-column-left = true; };
      "Mod+J" = { focus-window-down = true; };
      "Mod+K" = { focus-window-up = true; };
      "Mod+L" = { focus-column-right = true; };
      "Mod+Shift+Left" = { move-column-left = true; };
      "Mod+Shift+Down" = { move-window-down = true; };
      "Mod+Shift+Up" = { move-window-up = true; };
      "Mod+Shift+Right" = { move-column-right = true; };
      "Mod+Shift+H" = { move-column-left = true; };
      "Mod+Shift+J" = { move-window-down = true; };
      "Mod+Shift+K" = { move-window-up = true; };
      "Mod+Shift+L" = { move-column-right = true; };
      "Mod+Home" = { focus-column-first = true; };
      "Mod+End" = { focus-column-last = true; };
      "Mod+Ctrl+Home" = { move-column-to-first = true; };
      "Mod+Ctrl+End" = { move-column-to-last = true; };
      "Mod+Ctrl+Left" = { focus-monitor-left = true; };
      "Mod+Ctrl+Down" = { focus-monitor-down = true; };
      "Mod+Ctrl+Up" = { focus-monitor-up = true; };
      "Mod+Ctrl+Right" = { focus-monitor-right = true; };
      "Mod+Ctrl+H" = { focus-monitor-left = true; };
      "Mod+Ctrl+J" = { focus-monitor-down = true; };
      "Mod+Ctrl+K" = { focus-monitor-up = true; };
      "Mod+Ctrl+L" = { focus-monitor-right = true; };
      "Mod+Shift+Ctrl+Left" = { move-column-to-monitor-left = true; };
      "Mod+Shift+Ctrl+Down" = { move-column-to-monitor-down = true; };
      "Mod+Shift+Ctrl+Up" = { move-column-to-monitor-up = true; };
      "Mod+Shift+Ctrl+Right" = { move-column-to-monitor-right = true; };
      "Mod+Shift+Ctrl+H" = { move-column-to-monitor-left = true; };
      "Mod+Shift+Ctrl+J" = { move-column-to-monitor-down = true; };
      "Mod+Shift+Ctrl+K" = { move-column-to-monitor-up = true; };
      "Mod+Shift+Ctrl+L" = { move-column-to-monitor-right = true; };
      "Mod+Page_Down" = { focus-workspace-down = true; };
      "Mod+Page_Up" = { focus-workspace-up = true; };
      "Mod+U" = { focus-workspace-down = true; };
      "Mod+I" = { focus-workspace-up = true; };
      "Mod+Ctrl+Page_Down" = { move-column-to-workspace-down = true; };
      "Mod+Ctrl+Page_Up" = { move-column-to-workspace-up = true; };
      "Mod+SHIFT+U" = { move-column-to-workspace-down = true; };
      "Mod+SHIFT+I" = { move-column-to-workspace-up = true; };
      "Mod+Shift+Page_Down" = { move-workspace-down = true; };
      "Mod+Shift+Page_Up" = { move-workspace-up = true; };
      "Mod+Ctrl+U" = { move-workspace-down = true; };
      "Mod+Ctrl+I" = { move-workspace-up = true; };
      "Mod+WheelScrollDown" = {
        _props = { cooldown-ms = 150; };
        focus-workspace-down = true;
      };
      "Mod+WheelScrollUp" = {
        _props = { cooldown-ms = 150; };
        focus-workspace-up = true;
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props = { cooldown-ms = 150; };
        move-column-to-workspace-down = true;
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props = { cooldown-ms = 150; };
        move-column-to-workspace-up = true;
      };
      "Mod+WheelScrollRight" = { focus-column-right = true; };
      "Mod+WheelScrollLeft" = { focus-column-left = true; };
      "Mod+Ctrl+WheelScrollRight" = { move-column-right = true; };
      "Mod+Ctrl+WheelScrollLeft" = { move-column-left = true; };
      "Mod+Shift+WheelScrollDown" = { focus-column-right = true; };
      "Mod+Shift+WheelScrollUp" = { focus-column-left = true; };
      "Mod+Ctrl+Shift+WheelScrollDown" = { move-column-right = true; };
      "Mod+Ctrl+Shift+WheelScrollUp" = { move-column-left = true; };
      "Mod+1" = { focus-workspace = 1; };
      "Mod+2" = { focus-workspace = 2; };
      "Mod+3" = { focus-workspace = 3; };
      "Mod+4" = { focus-workspace = 4; };
      "Mod+5" = { focus-workspace = 5; };
      "Mod+6" = { focus-workspace = 6; };
      "Mod+7" = { focus-workspace = 7; };
      "Mod+8" = { focus-workspace = 8; };
      "Mod+9" = { focus-workspace = 9; };
      "Mod+Shift+1" = { move-column-to-workspace = 1; };
      "Mod+Shift+2" = { move-column-to-workspace = 2; };
      "Mod+Shift+3" = { move-column-to-workspace = 3; };
      "Mod+Shift+4" = { move-column-to-workspace = 4; };
      "Mod+Shift+5" = { move-column-to-workspace = 5; };
      "Mod+Shift+6" = { move-column-to-workspace = 6; };
      "Mod+Shift+7" = { move-column-to-workspace = 7; };
      "Mod+Shift+8" = { move-column-to-workspace = 8; };
      "Mod+Shift+9" = { move-column-to-workspace = 9; };
      "Mod+BracketLeft" = { consume-or-expel-window-left = true; };
      "Mod+BracketRight" = { consume-or-expel-window-right = true; };
      "Mod+Comma" = { consume-window-into-column = true; };
      "Mod+Period" = { expel-window-from-column = true; };
      "Mod+R" = { switch-preset-column-width = true; };
      "Mod+Shift+R" = { switch-preset-window-height = true; };
      "Mod+Ctrl+R" = { reset-window-height = true; };
      "Mod+F" = { maximize-column = true; };
      "Mod+Shift+F" = { fullscreen-window = true; };
      "Mod+Ctrl+F" = { expand-column-to-available-width = true; };
      "Mod+C" = { center-column = true; };
      "Mod+Ctrl+C" = { center-visible-columns = true; };
      "Mod+Minus" = { set-column-width = "-10%"; };
      "Mod+Equal" = { set-column-width = "+10%"; };
      "Mod+Shift+Minus" = { set-window-height = "-10%"; };
      "Mod+Shift+Equal" = { set-window-height = "+10%"; };
      "Mod+V" = { toggle-window-floating = true; };
      "Mod+Shift+V" = { switch-focus-between-floating-and-tiling = true; };
      "Mod+W" = { toggle-column-tabbed-display = true; };
      "Print" = { screenshot = true; };
      "Ctrl+Print" = { screenshot-screen = true; };
      "Alt+Print" = { screenshot-window = true; };
      "Mod+Escape" = {
        _props = { allow-inhibiting = false; };
        toggle-keyboard-shortcuts-inhibit = true;
      };
      "Mod+Shift+E" = { quit = true; };
      "Ctrl+Alt+Delete" = { quit = true; };
      "Mod+Shift+P" = { power-off-monitors = true; };
    };
  };
}
