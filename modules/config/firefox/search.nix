_: {
  programs.firefox.search = {
    engines = [
      {
        name = "Nix Packages";
        url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        alias = "@np";
      }
      {
        name = "GitHub";
        url = "https://github.com/search?q={searchTerms}";
        alias = "@gh";
      }
    ];

    default = "Nix Packages";
  };
}
