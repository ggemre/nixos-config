_: {
  programs.firefox.search = {
    engines = [
      {
        name = "Brave";
        url = "https://search.brave.com/search?q={searchTerms}&source=web";
        alias = "@brave";
      }
      {
        name = "Nix Packages";
        url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        alias = "@np";
      }
      {
        name = "Nix Options";
        url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
        alias = "@no";
      }
      {
        name = "GitHub";
        url = "https://github.com/search?q={searchTerms}";
        alias = "@gh";
      }
      {
        name = "NUR";
        url = "https://searchix.ovh/packages/nur/search?query={searchTerms}";
        alias = "@nur";
      }
    ];

    default = "Brave";
  };
}
