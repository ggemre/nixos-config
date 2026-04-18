{selfModules, ...}: {
  imports = [
    # Host specific modules
    ./configuration.nix

    # Configure programs & services
    selfModules.config.bash
    selfModules.config.git
    selfModules.config.helix
  ];
}
