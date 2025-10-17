{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.dwl;
in {
  options.programs.dwl = {
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the config header file.";
    };

    patches = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = "List of patches to apply to dwl.";
    };

    buildInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of additional build inputs.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dwl = {
      package =
        (pkgs.dwl.override {
          enableXWayland = true;
          configH = cfg.configFile;
        }).overrideAttrs (oldAttrs: {
          buildInputs =
            oldAttrs.buildInputs or []
            ++ cfg.buildInputs;
          patches = oldAttrs.patches or [] ++ cfg.patches;
        });
    };
  };
}
