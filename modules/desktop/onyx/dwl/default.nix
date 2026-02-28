{pkgs, ...}: {
  programs.dwl.enable = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];

  security.rtkit.enable = true;
}
