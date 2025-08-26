{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ly;
  waylandSessionsPath = "${cfg.waylandCompositor}/share/wayland-sessions";
in {
  options.programs.ly = {
    enable = lib.mkEnableOption "ly display manager";
    waylandCompositor = lib.mkOption {
      type = lib.types.package;
      description = "Command to launch after logging in.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.pathExists waylandSessionsPath;
        message = ''
          The package specified in programs.greetd.command (${cfg.waylandCompositor.pname or cfg.waylandCompositor.name})
          does not provide share/wayland-sessions.
        '';
      }
    ];

    services.displayManager.ly = {
      enable = true;
      settings = {
        save = true;
        waylandsessions = waylandSessionsPath;
        # none, doom, matrix, colormix, or gameoflife
        animation = "matrix";
      };
    };
  };
}
