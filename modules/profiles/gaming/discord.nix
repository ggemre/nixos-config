{self, ...}: {
  imports = [ self.nixosModules.programs.discord ];

  programs.discord.enable = true;
}
