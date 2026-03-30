{selfModules, ...}: {
  imports = [
    # Host specific modules
    ./configuration.nix
    ./hardware.nix

    # Configure programs & services
    selfModules.config.bash
    selfModules.config.git
    selfModules.config.helix

    # Include any desired profiles
    selfModules.profiles.server
  ];
}
