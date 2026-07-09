{
  lib,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    vteIntegration = true;
    shellAliases = {
      ls = lib.getExe pkgs.eza;
    };
  };

  environment.variables = {
    # TODO: set xdg vars and make sure this works on fresh install.
    HISTFILE = "$HOME/.local/state/bash/history";
  };
}
