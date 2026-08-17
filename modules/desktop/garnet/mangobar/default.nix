{config, ...}: {
  programs.mangobar = {
    enable = true;

    settings = {
      layer = "top";
      height = 12;
      buffer-scale = 1;

      modules-left = [
        "workspaces"
        "layout"
      ];

      modules-center = [];

      modules-right = [
        "tray"
        "network"
        "cpu"
        "memory"
        "custom/disk"
        "pulseaudio"
        "battery"
        "clock"
      ];

      workspaces = {
        hide-empty = true;
        overview-label = "Overview";
        on-click = "activate";
        on-click-right = "toggle";
      };

      layout = {
        format = "[{}]";
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };

      network = {
        format = "NET {ifname} |";
        format-alt = "NET {down} |";
      };

      cpu = {
        format = "CPU {load}% |";
      };

      memory = {
        format = "MEM {}% |";
      };

      "custom/disk" = {
        exec = "df -h / | awk 'NR==2{gsub(/%/,\"\",$5); print $5\"%\"}'";
        format = "DSK {} |";
        interval = 120;
      };

      pulseaudio = {
        format = "VOL {volume}% |";
        format-muted = "VOL [M] {volume}% |";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      battery = {
        format = "BAT {percent}% |";
      };

      clock = {
        format = "{:L%a %b %d %I:%M}";
      };
    };

    style = ''
      * {
          font-family: "sansSerif";
          font-size: 9px;
          font-weight: bold;

          color: ${config.theme.colorsWithHashtag.base05};
          background: none;
          padding: 0;
          margin: 5px;
      }

      #bar {
          background: none;
          margin: 1px;
      }
      #bar.sel {
          background: none;
      }

      #tags {
          padding: 0px 5px;
          margin: 0px 2px;
      }

      #tags.active {
          background-color: ${config.theme.colorsWithHashtag.base0D};
          color: ${config.theme.colorsWithHashtag.base01};
      }
      #tags.occupied {
          background-color: ${config.theme.colorsWithHashtag.base04};
          color: ${config.theme.colorsWithHashtag.base05};
      }
      #tags.urgent {
          background-color: ${config.theme.colorsWithHashtag.base09};
          color: ${config.theme.colorsWithHashtag.base01};
      }

      #overview {
          background-color: ${config.theme.colorsWithHashtag.base0D};
          color: ${config.theme.colorsWithHashtag.base01};
      }
    '';
  };
}
