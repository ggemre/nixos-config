{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.ripgrep
    pkgs.wl-clipboard
  ];
}
