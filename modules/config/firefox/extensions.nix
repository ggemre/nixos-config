{selfPkgs, ...}: {
  programs.firefox.profiles.main.extensions = {
    packages = [
      selfPkgs.mozilla-addons.ublock-origin
    ];
  };
}
