{
  config,
  self,
  ...
}: {
  services.desktopManager.cosmic.settings."com.system76.CosmicTheme.Dark".v1 = {
    accent = {
      base = self.lib.colors.ron config.theme.colors.base00 0.1;
      hover = self.lib.colors.ron config.theme.colors.base01 0.1;
      pressed = self.lib.colors.ron config.theme.colors.base02 0.1;
      selected = self.lib.colors.ron config.theme.colors.base03 0.1;
      selected_text = self.lib.colors.ron config.theme.colors.base04 0.1;
      focus = self.lib.colors.ron config.theme.colors.base05 0.1;
      divider = self.lib.colors.ron config.theme.colors.base06 0.1;
      on = self.lib.colors.ron config.theme.colors.base07 0.1;
      disabled = self.lib.colors.ron config.theme.colors.base08 0.1;
      on_disabled = self.lib.colors.ron config.theme.colors.base09 0.1;
      border = self.lib.colors.ron config.theme.colors.base0A 0.1;
      disabled_border = self.lib.colors.ron config.theme.colors.base0B 0.1;
    };
    # success = {
    #   base = self.lib.colors.ron config.theme.colors.base00 0.1;
    #   hover = self.lib.colors.ron config.theme.colors.base01 0.1;
    # };
  };
}
