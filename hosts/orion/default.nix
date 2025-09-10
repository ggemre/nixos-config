{self, ...}: {
  imports = [
    ./configuration.nix
    ./hardware.nix

    self.nixosModules.config.bash
    self.nixosModules.config.brave
    self.nixosModules.config.direnv
    self.nixosModules.config.firefox
    self.nixosModules.config.foot
    self.nixosModules.config.git
    self.nixosModules.config.helix
    self.nixosModules.config.starship

    self.nixosModules.desktop.amethyst

    self.nixosModules.profiles.hardware.apple-macbook-air-7
    self.nixosModules.profiles.graphical
    self.nixosModules.profiles.laptop
  ];
}
