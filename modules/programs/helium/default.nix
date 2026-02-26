{
  config,
  lib,
  nurPkgs,
  ...
}: let
  cfg = config.programs.helium;
in {
  options.programs.helium = {
    enable = lib.mkEnableOption "Whether to enable the Helium browser.";
    package = lib.mkPackageOption nurPkgs [ "forkprince" "helium-nightly" ] {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    nix.settings = {
      substituters = [
        "https://forkprince.cachix.org"
      ];

      trusted-public-keys = [
        "forkprince.cachix.org-1:9cN+fX492ZKlfd228xpYAC3T9gNKwS1sZvCqH8iAy1M="
      ];
    };

    # TODO: configurable policies, preferences, & extensions
  };
}
