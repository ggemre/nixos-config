{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.services.hypridle
  ];

  services.hypridle = {
    enable = true;

    settings = {
      listener = [
        {
          timeout = 300; # 5m
          on-timeout = "${lib.getExe pkgs.brightnessctl} set 0 --save && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight set 0 --save";
          on-resume = "${lib.getExe pkgs.brightnessctl} --restore && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight --restore";
        }
        {
          timeout = 480; # 8m
          on-timeout = lib.getExe config.programs.hyprlock.package;
        }
        {
          timeout = 960; # 16m
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
