{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wmenu;

  wrappedWmenu = pkgs.symlinkJoin {
    name = "${lib.getName cfg.package}-wrapped-${lib.getVersion cfg.package}";
    paths = [ cfg.package ];
    preferLocalBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      ${lib.optionalString (cfg.flags != null) ''
        wrapProgram $out/bin/wmenu-run --add-flags "${cfg.flags}"
      ''}
    '';
  };
in {
  options.programs.wmenu = {
    enable = lib.mkEnableOption "Whether to enable the wmenu launcher.";
    package = lib.mkPackageOption pkgs "wmenu" {};

    flags = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Custom flags to pass to wmenu when wrapping it.";
    };

    runner = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Because of wmenu oddities, call this to get the launcher.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ wrappedWmenu ];
    programs.wmenu.runner = "${wrappedWmenu}/bin/wmenu-run";
  };
}
