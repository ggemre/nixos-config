{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ripgrep;
in {
  options.programs.ripgrep = {
    enable = lib.mkEnableOption "Whether to enable ripgrep.";
    package = lib.mkPackageOption pkgs "ripgrep" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
