{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.windowManagers.hyprland;
  generator = import ./generator.nix {inherit lib;};
in {
  options.windowManagers.hyprland = {
    enable = lib.mkEnableOption "hyprland window manager";

    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
        valueType;
      default = {
        exec-once = [];
        misc.disable_hyprland_logo = true;
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = 0; # -1.0 to 1.0
        };
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        gestures.workspace_swipe = "off";

        "$mod" = "SUPER";

        bind = [
          "$mod, T, exec, ghostty"
          "$mod, B, exec, firefox"
          "$mod, SPACE, exec, rofi-launcher"
          "$mod, Q, killactive"
          "$mod, M, exit"
          "$mod SHIFT, L, exec, hyprlock"
          "$mod, V, togglefloating"
          "$mod, P, pseudo, # dwindle"
          "$mod, H, togglesplit, # dwindle"
          "$mod, S, togglespecialworkspace"
          "$mod, F, fullscreen, 0"
          "$mod SHIFT, S, movetoworkspace, special"

          ", XF86AudioMute, exec, amixer set Master toggle"

          # Move focus with mainMod + arrow/hx keys
          "$mod, left, movefocus, l"
          "$mod, down, movefocus, d"
          "$mod, up, movefocus, u"
          "$mod, right, movefocus, r"
          "$mod, J, movefocus, l"
          "$mod, K, movefocus, d"
          "$mod, L, movefocus, u"
          "$mod, semicolon, movefocus, r"

          # Swap window in given direction
          "$mod SHIFT, left, swapwindow, l"
          "$mod SHIFT, down, swapwindow, d"
          "$mod SHIFT, up, swapwindow, u"
          "$mod SHIFT, right, swapwindow, r"
          "$mod SHIFT, J, swapwindow, l"
          "$mod SHIFT, K, swapwindow, d"
          "$mod SHIFT, L, swapwindow, u"
          "$mod SHIFT, semicolon, swapwindow, r"

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
        ];

        binde = [
          ", XF86AudioLowerVolume, exec, amixer set Master 3%-"
          ", XF86AudioRaiseVolume, exec, amixer set Master 3%+"
          ", XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight s 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight s 5%+"
          ", XF86KbdBrightnessDown, exec, brightnessctl -d smc::kbd_backlight s 5%-"
          ", XF86KbdBrightnessUp, exec, brightnessctl -d smc::kbd_backlight s 5%+"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    homeless.".config/hypr/hyprland.conf".text = generator.toHyprConf cfg.settings;
  };
}
