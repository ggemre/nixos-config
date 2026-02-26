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

    preferences = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Initial preferences to configure Helium.";
    };

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make Helium the default browser.";
    };
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

    # Helium makes it clear they don't want us editing this file, but also provide no declarative alternative.
    home.".config/net.imput.helium/Default/Preferences" = lib.mkIf (cfg.preferences != {}) {
      text = builtins.toJSON cfg.preferences;
    };

    environment.variables = lib.mkIf cfg.defaultBrowser {
      BROWSER = cfg.package;
    };

    common.mime = lib.mkIf cfg.defaultBrowser {
      browser = "helium.desktop";
    };
  };
}
