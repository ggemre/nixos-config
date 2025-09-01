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

    pictures = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "XDG user directory for pictures.";
    };
  };

  config = let
    directories = lib.filterAttrs (_: v: v != null) {
      XDG_DOCUMENTS_DIR = cfg.documents;
      XDG_DOWNLOAD_DIR = cfg.download;
      XDG_PICTURES_DIR = cfg.pictures;
    };

    formattedDirectories = lib.mapAttrs (_: value: ''"${value}"'') directories;
  in
    lib.mkIf (directories != {}) {
      homeless.".config/user-dirs.dirs".text = lib.generators.toKeyValue {} formattedDirectories;

      environment.variables = directories;
    };
}
