{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.bitwarden;
in {
  options.programs.bitwarden = {
    enable = lib.mkEnableOption "Whether to enable bitwarden.";
    package = lib.mkPackageOption pkgs "bitwarden-desktop" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
