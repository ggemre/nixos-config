{self, ...}: {
  imports = [ self.nixosModules.programs.bitwarden ];

  programs.bitwarden.enable = true;
}
