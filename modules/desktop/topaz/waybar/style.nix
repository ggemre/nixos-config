{config, ...}: {
  programs.waybar.style =
    ''
      @define-color base00 ${config.theme.colorsWithHashtag.base00};
      @define-color base01 ${config.theme.colorsWithHashtag.base01};
      @define-color base02 ${config.theme.colorsWithHashtag.base02};
      @define-color base03 ${config.theme.colorsWithHashtag.base03};
      @define-color base04 ${config.theme.colorsWithHashtag.base04};
      @define-color base05 ${config.theme.colorsWithHashtag.base05};
      @define-color base06 ${config.theme.colorsWithHashtag.base06};
      @define-color base07 ${config.theme.colorsWithHashtag.base07};
      @define-color base08 ${config.theme.colorsWithHashtag.base08};
      @define-color base09 ${config.theme.colorsWithHashtag.base09};
      @define-color base0A ${config.theme.colorsWithHashtag.base0A};
      @define-color base0B ${config.theme.colorsWithHashtag.base0B};
      @define-color base0C ${config.theme.colorsWithHashtag.base0C};
      @define-color base0D ${config.theme.colorsWithHashtag.base0D};
      @define-color base0E ${config.theme.colorsWithHashtag.base0E};
      @define-color base0F ${config.theme.colorsWithHashtag.base0F};
    ''
    + builtins.readFile ./style.css;
}
