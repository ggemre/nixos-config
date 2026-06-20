{
  config,
  lib,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 300; # 5m
        command = "${lib.getExe pkgs.brightnessctl} set 0 --save && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight set 0 --save";
        resume = "${lib.getExe pkgs.brightnessctl} --restore && ${lib.getExe pkgs.brightnessctl} --device=tpacpi::kbd_backlight --restore";
      }
      {
        timeout = 420; # 7m
        command = "${lib.getExe config.programs.swaylock.package}";
      }
      {
        timeout = 600; # 10m
        command = "${lib.getExe' config.programs.mangowc.package "mmsg"} dispatch disable_monitor";
        resume = "${lib.getExe' config.programs.mangowc.package "mmsg"} dispatch enable_monitor";
      }
    ];
  };
}
