{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.discord
    pkgs.prismlauncher
  ];
}
