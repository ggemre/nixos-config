{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv = {
      enable = true;
      # TODO: reenable when mimalloc ref fixed
      # package = pkgs.lixPackageSets.latest.nix-direnv;
    };
  };
}
