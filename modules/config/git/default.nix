{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;

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
        ls = "log --pretty=format:'%C(yellow)%h %Creset%cd %Cblue[%cn] %Creset%s %Cred%d' --date='format-local:%Y-%m-%d %H:%M'";
      };
    };
  };
}
