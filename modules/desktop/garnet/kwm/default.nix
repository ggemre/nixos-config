_: {
  imports = [
    ./bar.nix
    ./binds.nix
    ./decorations.nix
  ];

  programs.kwm = {
    enable = true;

    settings = {
    };
  };
}
