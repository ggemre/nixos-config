_: {
  programs.firefox.profiles.youtube.search = {
    engines = [
      {
        name = "YouTube";
        url = "https://www.youtube.com/results?search_query={searchTerms}";
        alias = "@yt";
      }
    ];

    default = "YouTube";
  };
}
