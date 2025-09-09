_: {
  services = {
    thermald.enable = true;
    libinput.enable = true;
    # Disable for now, rather aggressive on Hyprland
    # tlp.enable = true;

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
  };
}
