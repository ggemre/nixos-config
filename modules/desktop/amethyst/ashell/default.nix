{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.ashell
  ];

  programs.ashell = {
    enable = true;

    settings = {
      outputs = "All";
      position = "Top";

      modules = {
        left = [
          "Workspaces"
          "Tray"
        ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          [ "Clock" "Privacy" "Settings" ]
        ];
      };

      window_title = {
        mode = "Title";
        truncate_title_after_length = 45;
      };

      system_info = {
        indicators = [ "Cpu" "Memory" "Temperature" { Disk = "/"; } ];
        temperature.sensor = "coretemp Package id 0";
      };

      clock.format = "%a %d %b %l:%M %p";

      settings.lock_cmd = "${lib.getExe pkgs.hyprlock} &";

      appearance = {
        background_color = config.theme.colorsWithHashtag.base00;
        primary_color = config.theme.colorsWithHashtag.base0D;
        secondary_color = config.theme.colorsWithHashtag.base01;
        success_color = config.theme.colorsWithHashtag.base0B;
        danger_color = config.theme.colorsWithHashtag.base09;
        text_color = config.theme.colorsWithHashtag.base05;

        workspace_colors = [
          config.theme.colorsWithHashtag.base0D
        ];

        special_workspace_colors = [
          config.theme.colorsWithHashtag.base0E
        ];

        style = "Islands";
      };
    };
  };
}
