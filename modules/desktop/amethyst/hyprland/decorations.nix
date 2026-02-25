{
  config,
  selfLib,
  ...
}: {
  programs.hyprland.settings = {
    general = {
      "col.active_border" = selfLib.colors.rgb config.theme.colors.base0D;
      "col.inactive_border" = selfLib.colors.rgb config.theme.colors.base03;
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      layout = "dwindle";
    };
    group = {
      "col.border_inactive" = selfLib.colors.rgb config.theme.colors.base03;
      "col.border_active" = selfLib.colors.rgb config.theme.colors.base0D;
      "col.border_locked_active" = selfLib.colors.rgb config.theme.colors.base0C;

      groupbar = {
        text_color = selfLib.colors.rgb config.theme.colors.base05;
        "col.active" = selfLib.colors.rgb config.theme.colors.base0D;
        "col.inactive" = selfLib.colors.rgb config.theme.colors.base03;
      };
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
        color = selfLib.colors.rgba config.theme.colors.base00 "99";
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
  };
}
