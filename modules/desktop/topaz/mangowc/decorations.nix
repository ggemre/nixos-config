{
  config,
  selfLib,
  ...
}: {
  programs.mangowc.settings = {
    gappih = 5;
    gappiv = 5;
    gappoh = 5;
    gappov = 10;

    scratchpadcolor = selfLib.colors.hexa config.theme.colors.base0E "FF";
    rootcolor = selfLib.colors.hexa config.theme.colors.base00 "FF";

    borderpx = 2;
    border_radius = 6;
    bordercolor = selfLib.colors.hexa config.theme.colors.base03 "FF";
    focuscolor = selfLib.colors.hexa config.theme.colors.base0D "FF";
  };
}
