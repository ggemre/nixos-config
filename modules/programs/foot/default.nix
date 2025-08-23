{
  lib,
  config,
  ...
}: let
  cfg = config.programs.foot;
in {
  # options.programs.foot = {
  #   enable = lib.mkEnableOption "foot terminal emulator";
  #   enableZshIntegration = lib.mkEnableOption "Whether to enable foot zsh integration.";
  #   enableBashIntegration = lib.mkEnableOption "Whether to enable foot bash integration.";
  #   enableFishIntegration = lib.mkEnableOption "Whether to enable foot fish integraiton.";
  # };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      # enable = true;
      # enableZshIntegration = cfg.enableZshIntegration;
      # enableBashIntegration = cfg.enableBashIntegration;
      # enableFishIntegration = cfg.enableFishIntegration;

      settings = {
        scrollback.lines = 5000;
        colors = {
          foreground = config.theme.colors.base05;
          background = config.theme.colors.base00;
          regular0 = config.theme.colors.base00;
          regular1 = config.theme.colors.base08;
          regular2 = config.theme.colors.base0B;
          regular3 = config.theme.colors.base0A;
          regular4 = config.theme.colors.base0D;
          regular5 = config.theme.colors.base0E;
          regular6 = config.theme.colors.base0C;
          regular7 = config.theme.colors.base05;
          bright0 = config.theme.colors.base02;
          bright1 = config.theme.colors.base08;
          bright2 = config.theme.colors.base0B;
          bright3 = config.theme.colors.base0A;
          bright4 = config.theme.colors.base0D;
          bright5 = config.theme.colors.base0E;
          bright6 = config.theme.colors.base0C;
          bright7 = config.theme.colors.base07;
          "16" = config.theme.colors.base09;
          "17" = config.theme.colors.base0F;
          "18" = config.theme.colors.base01;
          "19" = config.theme.colors.base02;
          "20" = config.theme.colors.base04;
          "21" = config.theme.colors.base06;
        };
      };
    };
  };
}
