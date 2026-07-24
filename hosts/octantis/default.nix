{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
    ./installer.nix
  ];
}
