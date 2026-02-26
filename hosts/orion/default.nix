{selfModules, ...}: {
  imports = [
    ./configuration.nix
    ./hardware.nix

    selfModules.config.bash
    selfModules.config.bat
    selfModules.config.bitwarden
    selfModules.config.brave
    selfModules.config.direnv
    selfModules.config.firefox
    selfModules.config.foot
    selfModules.config.git
    selfModules.config.helium
    selfModules.config.helix
    selfModules.config.ripgrep
    selfModules.config.spotify
    selfModules.config.starship
    selfModules.config.yazi

    selfModules.desktop.amethyst

    selfModules.profiles.gaming
    selfModules.profiles.graphical
    selfModules.profiles.hardware.apple-macbook-air-7
    selfModules.profiles.laptop
  ];
}
