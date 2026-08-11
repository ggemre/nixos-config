{config, ...}: let
  sharedUserChrome = import ../shared/user-chrome.nix { inherit config; };
in {
  programs.firefox.profiles.main.userChrome =
    sharedUserChrome
    ++ ''

    '';
}
