{self, ...}: {
  imports = [
    self.nixosModules.programs.dwl
  ];

  programs.dwl = {
    enable = true;
    configFile = ./config.h;
  };
}
