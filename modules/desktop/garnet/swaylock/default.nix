{config, ...}: {
  programs.swaylock = {
    enable = true;

    settings = {
      font-size = 11;
      font = "sans-serif";
      indicator-radius = 50;
      indicator-thickness = 10;

      show-failed-attempts = true;
      indicator-idle-visible = false;
      indicator-caps-lock = true;
      show-keyboard-layout = false;
      line-uses-inside = false;
      line-uses-ring = false;

      # background
      color = config.theme.colors.base00;

      # text
      text-color = config.theme.colors.base05;
      text-clear-color = config.theme.colors.base05;
      text-ver-color = config.theme.colors.base0B;
      text-wrong-color = config.theme.colors.base08;
      text-caps-lock-color = config.theme.colors.base0A;

      # main ring
      ring-color = config.theme.colors.base0D;
      ring-clear-color = config.theme.colors.base0C;
      ring-ver-color = config.theme.colors.base0B;
      ring-wrong-color = config.theme.colors.base08;
      ring-caps-lock-color = config.theme.colors.base0A;

      # indicator fill
      inside-color = config.theme.colors.base01;
      inside-clear-color = config.theme.colors.base01;
      inside-ver-color = config.theme.colors.base01;
      inside-wrong-color = config.theme.colors.base01;
      inside-caps-lock-color = config.theme.colors.base01;

      # separator line
      line-color = config.theme.colors.base02;
      line-clear-color = config.theme.colors.base02;
      line-ver-color = config.theme.colors.base02;
      line-wrong-color = config.theme.colors.base02;
      line-caps-lock-color = config.theme.colors.base02;
      separator-color = config.theme.colors.base02;

      # highlights while typing
      key-hl-color = config.theme.colors.base0E;
      bs-hl-color = config.theme.colors.base09;
      caps-lock-key-hl-color = config.theme.colors.base0A;
      caps-lock-bs-hl-color = config.theme.colors.base09;

      # keyboard layout popup
      layout-bg-color = config.theme.colors.base01;
      layout-border-color = config.theme.colors.base0D;
      layout-text-color = config.theme.colors.base05;
    };
  };
}
