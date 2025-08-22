{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.greetd;
in {
  options.programs.greetd = {
    enable = lib.mkEnableOption "dwl window manager";
    command = lib.mkOption {
      type = lib.types.string;
      default = "sh";
      description = ''
        Command to launch after logging in.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${cfg.command}";
        };
      };
    };
  };
}
