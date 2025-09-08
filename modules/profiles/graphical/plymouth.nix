{pkgs, ...}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "loader_2";
      themePackages = [
        # https://github.com/adi1090x/plymouth-themes
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "loader_2" ];
        })
      ];
    };

    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
  };
}
