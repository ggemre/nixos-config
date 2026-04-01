{
  config,
  lib,
  ...
}: let
  cfg = config.programs.firefox;

  # Function taken from
  # https://github.com/nix-community/home-manager/blob/1ce9e62690dfdd7e76bd266ccb9a887778410eb2/modules/programs/firefox/mkFirefoxModule.nix#L75
  userPrefValue = pref:
    builtins.toJSON (
      if lib.isBool pref || lib.isInt pref || lib.isString pref
      then pref
      else builtins.toJSON pref
    );

  userJsFile = lib.concatStrings (
    lib.mapAttrsToList (name: value: ''
      user_pref("${name}", ${userPrefValue value});
    '')
    cfg.settings
  );
in {
  options.programs.firefox = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to write to user.js.";
    };
  };

  config = lib.mkIf (cfg.enable && (cfg.settings != {})) {
    home.".config/mozilla/firefox/main/user.js".text = userJsFile;
  };
}
