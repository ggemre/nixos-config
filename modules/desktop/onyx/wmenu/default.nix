{self, ...}: {
  imports = [
    self.nixosModules.programs.wmenu
  ];
  programs.wmenu = {
    enable = true;
  };
}
