{
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.hyprlauncher
  ];

  programs.hyprlauncher = {
    enable = true;

    settings = {
      finders = {
        desktop_icons = false;
      };

      ui = {
        window_size = "400 300";
      };
    };

    style = {
      background = self.lib.colors.rgb config.theme.colors.base00;
      base = self.lib.colors.rgb config.theme.colors.base01;
      text = self.lib.colors.rgb config.theme.colors.base05;
      accent = self.lib.colors.rgb config.theme.colors.base0D;
      accent_secondary = self.lib.colors.rgb config.theme.colors.base03;
    };
  };
}
