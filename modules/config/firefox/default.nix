{self, ...}: {
  imports = [
    self.nixosModules.programs.firefox
    ./preferences.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    preferencesStatus = "locked";
    userChrome = ./userChrome.css;
    searchJsonArchive = ./search.json.mozlz4;
  };
}
