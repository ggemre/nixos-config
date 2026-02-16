{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.discord;
in {
  options.programs.discord = {
    enable = lib.mkEnableOption "Whether to enable discord.";
    package = lib.mkPackageOption pkgs "discord" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
