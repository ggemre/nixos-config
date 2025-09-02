{
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.hyprlock
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
        ignore_empty_input = true;
      };
      background = {
        path = "screenshot";
        blur_passes = 2;
        brightness = 0.5;
      };
      label = [
        {
          text = "$TIME";
          font_size = 30;
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          text = "Hi, $USER";
          font_size = 30;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = {
        position = "0, 0";
        size = "150, 25";
        dots_size = 0.33;
        dots_spacing = 0.15;
        placeholder_text = "Password...";
        fail_text = "Try again";
        outer_color = self.lib.colors.rgb config.theme.colors.base03;
        inner_color = self.lib.colors.rgb config.theme.colors.base00;
        font_color = self.lib.colors.rgb config.theme.colors.base05;
        fail_color = self.lib.colors.rgb config.theme.colors.base08;
        check_color = self.lib.colors.rgb config.theme.colors.base0A;
      };
    };
  };
}
