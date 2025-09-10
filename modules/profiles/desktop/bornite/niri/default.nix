{self, ...}: {
  imports = [
    self.nixosModules.programs.niri
    ./settings.nix
  ];

  programs.niri = {
    enable = true;
  };
}
