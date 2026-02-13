{self, ...}: {
  imports = [ self.nixosModules.programs.spotify ];

  programs.spotify.enable = true;
}
