{pkgs, ...}: {
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override {
          variant = "mocha";
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
