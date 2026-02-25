{selfModules, ...}: {
  imports = [ selfModules.programs.bitwarden ];

  programs.bitwarden.enable = true;
}
