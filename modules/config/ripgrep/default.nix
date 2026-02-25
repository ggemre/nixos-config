{selfModules, ...}: {
  imports = [ selfModules.programs.ripgrep ];

  programs.ripgrep.enable = true;
}
