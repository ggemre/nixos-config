{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;

    config = {
      user = {
        name = "ggemre";
        email = "80432807+ggemre@users.noreply.github.com";
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
