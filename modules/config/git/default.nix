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

      alias = {
        s = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      };
    };
  };
}
