{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.dwl
  ];

  programs.dwl.enable = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];
}
