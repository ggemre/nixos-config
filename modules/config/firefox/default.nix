_: {
  imports = [
    ./policies.nix
    ./profiles
  ];

  programs.firefox.enable = true;
}
