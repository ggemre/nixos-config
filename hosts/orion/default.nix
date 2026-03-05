{selfModules, ...}: {
  imports = [
    # Host specific modules
    ./configuration.nix
    ./hardware.nix

    # Configure programs & services
    selfModules.config.bash
    selfModules.config.bat
    selfModules.config.bitwarden
    selfModules.config.direnv
    selfModules.config.firefox
    selfModules.config.foot
    selfModules.config.git
    selfModules.config.helium
    selfModules.config.helix
    selfModules.config.spotify
    selfModules.config.starship
    selfModules.config.utils
    selfModules.config.yazi

    # Set a desktop environment
    selfModules.desktop.topaz

    # Include any desired profiles
    selfModules.profiles.gaming
    selfModules.profiles.graphical
    selfModules.profiles.hardware.apple-macbook-air-7
    selfModules.profiles.laptop
  ];
}
