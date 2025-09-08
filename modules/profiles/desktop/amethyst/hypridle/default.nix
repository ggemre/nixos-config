{
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
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5m
          on-timeout = "${lib.getExe pkgs.brightnessctl} set 0 --save && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight set 0 --save";
          on-resume = "${lib.getExe pkgs.brightnessctl} --restore && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight --restore";
        }
        {
          timeout = 480; # 8m
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 960; # 16m
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30m
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
