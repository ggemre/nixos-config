_: {
  imports = [
    ./colors.nix
    ./plugins.nix
    ./settings.nix
  ];

  programs.noctalia = {
    enable = true;
  };
}
