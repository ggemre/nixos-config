_: {
  imports = [
    ./colors.nix
    ./plugins.nix
    ./settings.nix
    ./plugins/privacy-indicator.nix
  ];

  programs.noctalia = {
    enable = true;
  };
}
