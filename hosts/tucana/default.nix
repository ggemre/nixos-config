{selfModules, ...}: {
  imports = [
    # Host specific modules
    ./configuration.nix
    ./hardware.nix

    # Configure programs & services
    selfModules.config.bash
    selfModules.config.git
    selfModules.config.helix
    selfModules.config.utils

    # Include any desired profiles
    selfModules.profiles.hardware.hp-pavilion-g6
  ];
}
