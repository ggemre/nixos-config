{
  config,
  selfLib,
  ...
}: let
  color = hexcode: (selfLib.colors.hexa config.theme.colors."base${hexcode}" "FF");
in {
  programs.mango.settings = {
    gap_inner_horizontal = 3;
    gap_inner_vertical = 3;
    gap_outer_horizontal = 3;
    gap_outer_vertical = 3;

    scratchpad_color = color "0E";
    root_color = color "01";

    border_px = 2;
    border_radius = 0;
    border_color = color "03";
    focus_color = color "0D";
    maximized_screen_color = color "03";
    global_color = color "06";

    animations = false;
  };
}
