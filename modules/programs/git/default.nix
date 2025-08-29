_: {
  programs.git = {
    enable = true;
    config = {
      user = {
        email = "ggemre+github@proton.me";
        name = "ggemre";
      };
      init.defaultBranch = "main";
      branch.autosetupmerge = "true";
      push.default = "current";
    };
  };
}
