_: {
  programs.waybar.settings = {
    layer = "top";
    spacing = 4;

    modules-left = [
      "ext/workspaces"
      "dwl/window"
    ];

    modules-right = [
      "tray"
      "network"
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
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
      format-icons = {
        default = "";
        active = "";
      };
    };

    "dwl/window" = {
      format = "{layout}{title}";
      rewrite = {
        "CT(.*)" = "󰕫 $1";
        "RT(.*)" = " $1";
        "VS(.*)" = "󰕯 $1";
        "VT(.*)" = "󰹫 $1";
        "VG(.*)" = "󱢈 $1";
        "VK(.*)" = "󰕵 $1";
        "TG(.*)" = "󰕮 $1";
        "S(.*)" = "󰕬 $1";
        "T(.*)" = " $1";
        "G(.*)" = "󰕰 $1";
        "M(.*)" = "󱟱 $1";
        "K(.*)" = " $1";
      };
    };

    tray = {
      icon-size = 20;
    };

    network = {
      format = "{icon} {essid}";
      format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
      format-disconnected = "󰤮";
    };

    clock = {
      format = "{:L%a, %b %d %I:%M %p}";
    };

    cpu = {
      interval = 2;
      format = " {usage}%";
    };

    memory = {
      format = " {percentage}%";
    };

    disk = {
      format = "󱛟 {percentage_used}%";
      path = "/";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-icons = {
        default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
      };
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+";
      on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-";
      scroll-step = 1;
      format-icons = {
        headphone = "";
        default = [ "" "" "" ];
      };
      format-muted = "";
      format-bluetooth = "󰂰";
    };
  };
}
