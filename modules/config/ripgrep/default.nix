{self, ...}: {
  imports = [ self.nixosModules.programs.ripgrep ];

  programs.ripgrep.enable = true;
}
