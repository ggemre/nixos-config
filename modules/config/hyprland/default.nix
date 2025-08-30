{
  pkgs,
  lib,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.hyprland
    ./binds.nix
    ./decorations.nix
  ];

  programs.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "${lib.getExe pkgs.waybar}"
      ];
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
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      gestures.workspace_swipe = "off";
    };
  };
}
