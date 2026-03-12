_: {
  imports = [
    ./preferences.nix
    ./policies.nix
    ./search.nix
    ./user-chrome.nix
  ];

  programs.firefox = {
    enable = true;
    preferencesStatus = "locked";
  };
}
