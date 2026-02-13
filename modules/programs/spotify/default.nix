{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.spotify;
in {
  options.programs.spotify = {
    enable = lib.mkEnableOption "Whether to enable the Spotify music player.";
    package = lib.mkPackageOption pkgs "spotify" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
