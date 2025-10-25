_: {
  services = {
    thermald.enable = true;
    libinput.enable = true;
    tlp.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    # Prevent shutdown on short power key press.
    logind.settings.Login = {
      HandlePowerKey = "ignore";
    };
  };
}
