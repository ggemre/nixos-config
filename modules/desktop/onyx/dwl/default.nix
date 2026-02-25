{
  pkgs,
  selfModules,
  ...
}: {
  imports = [
    selfModules.programs.dwl
  ];

  programs.dwl.enable = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];

  security.rtkit.enable = true;
}
