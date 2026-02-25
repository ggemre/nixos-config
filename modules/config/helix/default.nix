{
  config,
  selfModules,
  ...
}: {
  imports = [
    selfModules.programs.helix
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    theme = config.theme.name;
  };
}
