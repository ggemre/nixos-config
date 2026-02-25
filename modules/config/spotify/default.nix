{selfModules, ...}: {
  imports = [ selfModules.programs.spotify ];

  programs.spotify.enable = true;
}
