_: {
  programs.waybar.settings = {
    layer = "top";
    spacing = 4;

    modules-left = [
      "ext/workspaces"
      "wlr/taskbar"
      "dwl/window"
    ];

    modules-right = [
      "tray"
      "network"
      "cpu"
      "memory"
      "temperature"
      # "pulseaudio"
      "backlight"
      "battery"
      "clock"
    ];

    "ext/workspaces" = {
      format = "{icon}";
      ignore-hidden = true;
      on-click = "activate";
      on-click-right = "deactivate";
      on-scroll-up = "mmsg -d viewtoleft_have_client";
      on-scroll-down = "mmsg -d viewtoright_have_client";
      sort-by-id = true;
    };

    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 20;
      all-outputs = false;
      tooltip-format = "{title}";
      markup = true;
      on-click = "activate";
      on-click-right = "close";
    };

    "dwl/window" = {
      format = "[{layout}]{title}";
    };

    tray = {
      icon-size = 20;
    };

    clock = {
      format = "{:%H:%M}";
      format-alt = "{:L%A, %b %d}";
    };

    cpu = {
      interval = 2;
      format = "{load}%";
    };

    memory = {
      format = "{}%";
    };

    temperature = {
      critical-threshold = 90;
      format = "{icon} {temperatureC}°C";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
    };

    # pulseaudio = {
    #   format = "{icon} {volume}%";
    #   on-click = "pamixer -t";
    #   on-scroll-up = "pamixer -i 2";
    #   on-scroll-down = "pamixer -d 2";
    #   scroll-step = 5;
    # };
  };
}
