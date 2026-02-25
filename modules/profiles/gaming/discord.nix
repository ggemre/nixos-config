{selfModules, ...}: {
  imports = [ selfModules.programs.discord ];

  programs.discord.enable = true;
}
