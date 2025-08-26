{
  lib,
  config,
  ...
}: let
  cfg = config.programs.git;
in {
  config = lib.mkIf cfg.enable {
    programs.git.config = {
      user = {
        email = "ggemre+github@proton.me";
        name = "ggemre";
      };
      init.defaultBranch = "main";
      branch.autosetupmerge = "true";
      push.default = "current";
    };
  };
}
