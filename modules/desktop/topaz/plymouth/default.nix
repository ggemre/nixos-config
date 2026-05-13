{pkgs, ...}: {
  boot = {
    consoleLogLevel = 3;
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

    kernelParams = [
      "quiet"
      "splash"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "boot.shell_on_fail"
    ];
  };
}
