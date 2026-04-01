_: {
  imports = [
    ./policies.nix
    ./search.nix
    ./settings.nix
    ./user-chrome.nix
  ];

  programs.firefox = {
    enable = true;
    profiles.main.isDefault = true;
  };
}
