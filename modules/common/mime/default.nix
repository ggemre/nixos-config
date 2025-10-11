# Thanks to @llakala for the module that inspired this one.
# https://github.com/llakala/nixos/blob/205ad64708e5f29a1a8f47a448e3a5f097132493/various/nixosModules/mimetypes.nix
{
  lib,
  config,
  ...
}: let
  cfg = config.common.mime;

  mkMimetypeOption = name:
    lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Desktop entry for the chosen ${name}.";
    };

  anyDefined = lib.any (v: v != null) (builtins.attrValues cfg);
in {
  options.common.mime = {
    browser = mkMimetypeOption "browser";
    editor = mkMimetypeOption "text editor";
    fileManager = mkMimetypeOption "file manager";
    terminal = mkMimetypeOption "terminal";
    extractor = mkMimetypeOption "file extractor/archiver";
    imageViewer = mkMimetypeOption "image viewer";
    videoViewer = mkMimetypeOption "video viewer";
    pdfViewer = mkMimetypeOption "PDF viewer";
  };

  config = lib.mkIf anyDefined {
    xdg = {
      mime = {
        enable = true;

        defaultApplications = lib.filterAttrs (_: v: v != null) {
          "text/html" = cfg.browser;
          "text/xml" = cfg.browser;
          "x-scheme-handler/http" = cfg.browser;
          "x-scheme-handler/https" = cfg.browser;
          "x-scheme-handler/unknown" = cfg.browser;

          "text/*" = cfg.editor;
          "text/plain" = cfg.editor;
          "application/x-zerosize" = cfg.editor;
          "application/x-trash" = cfg.editor;
          "application/json" = cfg.editor;
          "text/markdown" = cfg.editor;

          "inode/directory" = cfg.fileManager;

          "application/*zip" = cfg.extractor;
          "application/gzip" = cfg.extractor;
          "application/rar" = cfg.extractor;
          "application/7z" = cfg.extractor;
          "application/*tar" = cfg.extractor;

          "image/*" = cfg.imageViewer;
          "video/*" = cfg.videoViewer;

          "application/pdf" = cfg.pdfViewer;
          "application/epub" = cfg.pdfViewer;
        };
      };

      terminal-exec = lib.mkIf (cfg.terminal != null) {
        enable = true;
        settings.default = [ cfg.terminal ];
      };
    };
  };
}
