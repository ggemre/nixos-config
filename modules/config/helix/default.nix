{self, ...}: {
  imports = [
    self.nixosModules.programs.helix
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
}
