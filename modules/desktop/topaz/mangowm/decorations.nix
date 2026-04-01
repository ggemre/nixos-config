{
  config,
  selfLib,
  ...
}: {
  programs.mangowm.settings = {
    gappih = 3;
    gappiv = 3;
    gappoh = 3;
    gappov = 3;

    scratchpadcolor = selfLib.colors.hexa config.theme.colors.base0E "FF";
    rootcolor = selfLib.colors.hexa config.theme.colors.base00 "FF";

    borderpx = 2;
    # border_radius = 6;
    bordercolor = selfLib.colors.hexa config.theme.colors.base03 "FF";
    focuscolor = selfLib.colors.hexa config.theme.colors.base0D "FF";
    maximizescreencolor = selfLib.colors.hexa config.theme.colors.base03 "FF";
    globalcolor = selfLib.colors.hexa config.theme.colors.base06 "FF";

    animations = false;
  };
}
