{self, ...}: {
  imports = [
    ./configuration.nix
    ./hardware.nix

    self.nixosModules.config.bash
    self.nixosModules.config.bat
    self.nixosModules.config.bitwarden
    self.nixosModules.config.brave
    self.nixosModules.config.direnv
    self.nixosModules.config.firefox
    self.nixosModules.config.foot
    self.nixosModules.config.git
    self.nixosModules.config.helix
    self.nixosModules.config.ripgrep
    self.nixosModules.config.starship
    self.nixosModules.config.yazi

    self.nixosModules.desktop.onyx

    self.nixosModules.profiles.gaming
    self.nixosModules.profiles.graphical
    self.nixosModules.profiles.hardware.apple-macbook-air-7
    self.nixosModules.profiles.laptop
  ];
}
