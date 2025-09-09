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
      wrapProgram $out/bin/wmenu-run \
        --add-flags "-bi -l 4 -N ${config.theme.colors.base00}D0 -n ${config.theme.colors.base05} -S ${config.theme.colors.base0D}D0 -s ${config.theme.colors.base00}"
    '';
  };
in {
  options.programs.wmenu = {
    enable = lib.mkEnableOption "Whether to enable the wmenu launcher.";
    package = lib.mkPackageOption pkgs "wmenu" {};
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
