{self, ...}: {
  imports = [
    self.nixosModules.programs.dwl
  ];

  programs.dwl.enable = true;
}
