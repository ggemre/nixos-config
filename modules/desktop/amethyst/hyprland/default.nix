{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  uwsm = lib.getExe pkgs.uwsm;
in {
  imports = [
    self.nixosModules.programs.hyprland
    ./binds.nix
    ./decorations.nix
  ];

  programs.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "${uwsm} app -- ${lib.getExe config.programs.ashell.package}"
        "${uwsm} app -- ${lib.getExe pkgs.wbg} --stretch $(find $XDG_PICTURES_DIR/wallpapers -type f | shuf -n 1)"
        "${uwsm} app -- ${lib.getExe config.services.hypridle.package}"
        "${uwsm} app -- ${lib.getExe config.services.hyprsunset.package}"
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
