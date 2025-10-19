{lib, ...}: let
  directories = {
    XDG_DOCUMENTS_DIR = "$HOME/docs";
    XDG_DOWNLOAD_DIR = "$HOME/tmp";
    XDG_PICTURES_DIR = "$HOM/media/pictures";
    XDG_DESKTOP_DIR = "$HOME/tmp/desktop";
    XDG_MUSIC_DIR = "$HOME/media/music";
    XDG_PUBLICSHARE_DIR = "$HOME/tmp/public";
    XDG_TEMPLATES_DIR = "$HOME/tmp/templates";
    XDG_VIDEOS_DIR = "$HOME/media/videos";
  };

  formattedDirectories = lib.mapAttrs (_: value: ''"${value}"'') directories;
in {
  homeless.".config/user-dirs.dirs".text = lib.generators.toKeyValue {} formattedDirectories;

  environment.variables = directories;
}
