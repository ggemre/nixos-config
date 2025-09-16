{
  config,
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
        "${lib.getExe pkgs.ashell}"
        "${lib.getExe pkgs.wbg} --stretch $(find $XDG_PICTURES_DIR/wallpapers -type f | shuf -n 1)"
        "${lib.getExe pkgs.hypridle}"
        "${lib.getExe pkgs.hyprsunset}"
      ];
      misc = {
        disable_hyprland_logo = true;
        background_color = self.lib.colors.rgb config.theme.colors.base00;
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
        sensitivity = 0; # -1.0 to 1.0
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
    };
  };
}
