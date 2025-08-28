{self, ...}: {
  imports = [
    ./configuration.nix
    ./hardware.nix

    self.nixosModules.programs.foot
    self.nixosModules.programs.firefox
    self.nixosModules.programs.git
    self.nixosModules.programs.helix
    self.nixosModules.programs.hyprland

    self.nixosModules.profiles.apple.macbook-air-7
    self.nixosModules.profiles.graphical
    self.nixosModules.profiles.laptop
  ];
}
