{
  config,
  lib,
  ...
}: let
  cfg = config.common.userDirs;
in {
  options.common.userDirs = {
    documents = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "XDG user directory for documents.";
    };

    download = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "XDG user directory for downloads.";
    };
  };

  config = let
    directories = lib.filterAttrs (_: v: !isNull v) {
      XDG_DOCUMENTS_DIR = cfg.documents;
      XDG_DOWNLOAD_DIR = cfg.download;
    };

    formattedDirectories = lib.mapAttrs (_: value: ''"${value}"'') directories;
  in
    lib.mkIf (directories
      != {}) {
      homeless.".config/user-dirs.dirs".text = lib.generators.toKeyValue {} formattedDirectories;
    };
}
