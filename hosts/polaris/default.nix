{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./broadcom.nix
    ./installer.nix
    ./tools.nix
  ];
}
