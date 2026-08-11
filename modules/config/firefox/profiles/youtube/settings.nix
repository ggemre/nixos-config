{config, ...}: let
  sharedSettings = import ../shared/settings.nix { inherit config; };
in {
  programs.firefox.profiles.youtube.settings =
    sharedSettings
    // {};
}
