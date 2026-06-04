{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.swayidle;

  generateTimeoutConfig = t:
    "timeout ${toString t.timeout} "
    + "\"${t.command}\""
    + lib.optionalString (t ? resume)
    " resume \"${t.resume}\"";

  generateSwayidleConfig = timeouts:
    lib.concatMapStringsSep "\n" generateTimeoutConfig timeouts;
in {
  options.services.swayidle = {
    enable = lib.mkEnableOption "Whether to enable the Swayidle idle daemon.";

    package = lib.mkPackageOption pkgs "swayidle" {};

    timeouts = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "Timeouts that will trigger commands in Swayidle.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
    };

    home.".config/swayidle/config" = lib.mkIf (cfg.timeouts != []) {
      text = generateSwayidleConfig cfg.timeouts;
    };
  };
}
