{
  config,
  selfLib,
  ...
}: let
  color = hexcode: (selfLib.colors.hexa config.theme.colors."base${hexcode}" "FF");
in {
  programs.mango.settings = {
    gappih = 3;
    gappiv = 3;
    gappoh = 3;
    gappov = 3;

    scratchpadcolor = color "0E";
    rootcolor = color "01";

    borderpx = 2;
    border_radius = 0;
    bordercolor = color "03";
    focuscolor = color "0D";
    maximizescreencolor = color "03";
    globalcolor = color "06";

    animations = false;
  };
}
