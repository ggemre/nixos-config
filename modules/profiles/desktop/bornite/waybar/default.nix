{self, ...}: {
  imports = [
    self.nixosModules.programs.waybar
  ];

  programs.waybar = {
    enable = true;

    settings = {
      position = "left";
      layer = "top";
      spacing = 0;
      width = 36;

      "modules-left" = [
        "niri/workspaces"
      ];

      "modules-right" = [
        "tray"
        "backlight"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "clock"
      ];
    };
  };
}
