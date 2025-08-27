{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.ly;
  waylandSessionsPath = "${cfg.waylandCompositor}/share/wayland-sessions";
in {
  options.services.displayManager.ly = {
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
      settings = {
        save = true;
        waylandsessions = waylandSessionsPath;
        # none, doom, matrix, colormix, or gameoflife
        animation = "matrix";
        session_log = "null";
      };
    };
  };
}
