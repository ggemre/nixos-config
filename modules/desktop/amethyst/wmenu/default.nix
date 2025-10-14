{
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.wmenu
  ];
  programs.wmenu = {
    enable = true;
    flags = ''
      -bi -l 4 \
      -N ${config.theme.colors.base00}D0 \
      -n ${config.theme.colors.base05} \
      -S ${config.theme.colors.base0D}D0 \
      -s ${config.theme.colors.base00}
    '';
  };
}
