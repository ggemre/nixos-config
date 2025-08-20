{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ghostty;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "ghostty terminal emulator";
    package = lib.mkPackageOption pkgs "ghostty" {example = "pkgs.ghostty";};
    theme.enable =
      lib.mkEnableOption "consistent theming"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    homeless = {
      ".config/ghostty/config".text = ''
        app-notifications = no-clipboard-copy
        background-opacity = 1.000000
        font-family = DejaVu Sans Mono
        font-family = Noto Color Emoji
        font-size = 12
        link-url = true
        theme = custom
        window-padding-x = 6
        window-padding-y = 6
      '';

      ".config/ghostty/themes/custom".text = lib.mkIf (config.theme.enable && cfg.theme.enable) ''
        background = ${config.theme.colors.base00}
        cursor-color = ${config.theme.colors.base05}
        foreground = ${config.theme.colors.base05}
        palette = 0=${config.theme.colorsWithHashtag.base00}
        palette = 1=${config.theme.colorsWithHashtag.base08}
        palette = 2=${config.theme.colorsWithHashtag.base0B}
        palette = 3=${config.theme.colorsWithHashtag.base0A}
        palette = 4=${config.theme.colorsWithHashtag.base0D}
        palette = 5=${config.theme.colorsWithHashtag.base0E}
        palette = 6=${config.theme.colorsWithHashtag.base0C}
        palette = 7=${config.theme.colorsWithHashtag.base05}
        palette = 8=${config.theme.colorsWithHashtag.base03}
        palette = 9=${config.theme.colorsWithHashtag.base08}
        palette = 10=${config.theme.colorsWithHashtag.base0B}
        palette = 11=${config.theme.colorsWithHashtag.base0A}
        palette = 12=${config.theme.colorsWithHashtag.base0D}
        palette = 13=${config.theme.colorsWithHashtag.base0E}
        palette = 14=${config.theme.colorsWithHashtag.base0C}
        palette = 15=${config.theme.colorsWithHashtag.base07}
        selection-background = ${config.theme.colors.base02}
        selection-foreground = ${config.theme.colors.base05}
      '';
    };
  };
}
