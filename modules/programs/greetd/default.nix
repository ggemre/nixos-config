{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.greetd;
in {
  options.programs.greetd = {
    enable = lib.mkEnableOption "greetd display manager";
    command = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
      description = "Command to launch after logging in.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --asterisks --cmd ${lib.getExe cfg.command}";
        };
      };
    };
  };
}
