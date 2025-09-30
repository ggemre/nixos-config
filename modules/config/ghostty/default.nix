{
  self,
  config,
  ...
}: {
  imports = [
    self.nixosModules.programs.ghostty
  ];

  programs.ghostty = {
    enable = true;

    settings = {
      app-notifications = "no-clipboard-copy";
      background-opacity = 1.0;
      font-size = 9;
      link-url = true;
      window-padding-x = 6;
      window-padding-y = 6;
    };

    theme = {
      background = config.theme.colors.base00;
      cursor-color = config.theme.colors.base05;
      foreground = config.theme.colors.base05;
      selection-background = config.theme.colors.base02;
      selection-foreground = config.theme.colors.base05;
      palette = [
        "0=${config.theme.colorsWithHashtag.base00}"
        "1=${config.theme.colorsWithHashtag.base08}"
        "2=${config.theme.colorsWithHashtag.base0B}"
        "3=${config.theme.colorsWithHashtag.base0A}"
        "4=${config.theme.colorsWithHashtag.base0D}"
        "5=${config.theme.colorsWithHashtag.base0E}"
        "6=${config.theme.colorsWithHashtag.base0C}"
        "7=${config.theme.colorsWithHashtag.base05}"
        "8=${config.theme.colorsWithHashtag.base03}"
        "9=${config.theme.colorsWithHashtag.base08}"
        "10=${config.theme.colorsWithHashtag.base0B}"
        "11=${config.theme.colorsWithHashtag.base0A}"
        "12=${config.theme.colorsWithHashtag.base0D}"
        "13=${config.theme.colorsWithHashtag.base0E}"
        "14=${config.theme.colorsWithHashtag.base0C}"
        "15=${config.theme.colorsWithHashtag.base07}"
      ];
    };
  };
}
