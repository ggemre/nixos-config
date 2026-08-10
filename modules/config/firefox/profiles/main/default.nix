_: {
  imports = [
    ./extensions.nix
    ./search.nix
    ./settings.nix
    ./user-chrome.nix
  ];

  programs.firefox.profiles.main.isDefault = true;
}
