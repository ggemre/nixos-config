{selfModules, ...}: {
  imports = [ selfModules.programs.helium ];

  programs.helium.enable = true;
}
