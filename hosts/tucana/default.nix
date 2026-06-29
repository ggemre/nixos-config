{selfModules, ...}: {
  imports = [
    # Host specific modules
    ./configuration.nix
    ./hardware.nix

    # Configure programs & services
    selfModules.config.bash
    selfModules.config.firefox
    selfModules.config.foot
    selfModules.config.git
    selfModules.config.helix
    selfModules.config.starship
    selfModules.config.utils

    # Set a desktop environment
    selfModules.desktop.garnet

    # Include any desired profiles
    selfModules.profiles.graphical
    selfModules.profiles.hardware.hp-pavilion-g6
    selfModules.profiles.laptop
  ];
}
