{selfPkgs, ...}: {
  programs.firefox.profiles.youtube.extensions.packages = [
    selfPkgs.mozilla-addons.ublock-origin
    selfPkgs.mozilla-addons.sponsorblock
  ];
}
