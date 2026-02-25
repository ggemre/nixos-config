{selfModules, ...}: {
  imports = [
    selfModules.programs.firefox
    ./preferences.nix
    ./policies.nix
    ./user-chrome.nix
  ];

  programs.firefox = {
    enable = true;
    preferencesStatus = "locked";
    searchJsonArchive = ./search.json.mozlz4;
    defaultBrowser = true;
  };
}
