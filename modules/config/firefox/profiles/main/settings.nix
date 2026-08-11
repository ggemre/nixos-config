{config, ...}: let
  sharedSettings = import ../shared/settings.nix { inherit config; };
in {
  programs.firefox.profiles.main.settings =
    sharedSettings
    // {};
}
