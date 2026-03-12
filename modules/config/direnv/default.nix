{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv = {
      enable = true;
      package = pkgs.lixPackageSets.latest.nix-direnv;
    };
  };
}
