{self, ...}: {
  imports = [
    ./configuration.nix
    ./hardware.nix

    self.nixosModules.config.ashell
    self.nixosModules.config.bash
    self.nixosModules.config.brave
    self.nixosModules.config.direnv
    self.nixosModules.config.foot
    self.nixosModules.config.git
    self.nixosModules.config.helix
    self.nixosModules.config.hyprland

    # TODO: please replace me...
    self.nixosModules.programs.firefox

    self.nixosModules.profiles.apple.macbook-air-7
    self.nixosModules.profiles.graphical
    self.nixosModules.profiles.laptop
  ];
}
