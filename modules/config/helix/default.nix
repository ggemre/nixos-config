{config, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    theme = config.theme.name;
  };
}
