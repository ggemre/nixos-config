{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.mako;

  # This function is courtesy of home manager's Mako module.
  # https://github.com/nix-community/home-manager/blob/080e8b48b0318b38143d5865de9334f46d51fce3/modules/services/mako.nix
  generateConfig = config: let
    formatValue = v:
      if builtins.isBool v
      then
        if v
        then "true"
        else "false"
      else toString v;

    globalSettings = lib.filterAttrs (_: v: !(lib.isAttrs v)) config;
    sectionSettings = lib.filterAttrs (_: v: lib.isAttrs v) config;

    globalLines = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: "${k}=${formatValue v}") globalSettings
    );

    formatSection = name: attrs:
      "\n[${name}]\n"
      + lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${formatValue v}") attrs);

    sectionLines = lib.concatStringsSep "\n" (lib.mapAttrsToList formatSection sectionSettings);
  in
    lib.mkMerge [
      globalLines
      (lib.mkIf (sectionSettings != {}) sectionLines)
    ];
in {
  options.services.mako = {
    enable = lib.mkEnableOption "Whether to enable the Mako notification service.";

    package = lib.mkPackageOption pkgs "mako" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings to apply to Mako.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.".config/mako/config" = lib.mkIf (cfg.settings != {}) {
      text = generateConfig cfg.settings;
    };
  };
}
