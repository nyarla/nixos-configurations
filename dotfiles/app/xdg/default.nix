{ lib, pkgs, ... }:
{
  xdg.desktopEntries = {
    thorium-reader = {
      name = "Thorium Reader";
      genericName = "ePub/PDF Reader";
      exec = "thorium-reader %U";
      terminal = false;
      mimeType = [
        "application/pdf"
        "application/epub+zip"
      ];
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        toMimeMap =
          apps:
          lib.attrsets.concatMapAttrs (
            app: mimeTypes: lib.attrsets.mergeAttrsList (lib.lists.map (mime: { "${mime}" = app; }) mimeTypes)
          ) apps;
      in
      toMimeMap {
        # web
        "firefox.desktop" = [
          # files
          "application/x-extension-htm"
          "application/x-extension-xhtml"
          "text/html"

          # schema
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];

        # ebooks
        "thorium-reader.desktop" = [
          "application/epub+zip"
        ];

        # files
        "pluma.desktop" = [
          "text/plain"
        ];

        "eom.desktop" = [
          "image/apng"
          "image/bmp"
          "image/gif"
          "image/jp2"
          "image/jpeg"
          "image/jpm"
          "image/jpx"
          "image/jxl"
          "image/jxr"
          "image/png"
          "image/svg+xml"
          "image/svg+xml-compressed"
          "image/tiff"
          "image/vnd.microsoft.icon"
          "image/webp"
        ];

        "deadbeef.desktop" = [
          "audio/flac"
          "audio/mpeg"
          "audio/ogg"
          "audio/webm"
          "audio/x-ape"
          "audio/x-flac+ogg"
          "audio/x-ms-wma"
          "audio/x-opus+ogg"
          "audio/x-vorbis+ogg"
        ];

        "atril.desktop" = [
          "application/epub+zip"
          "application/pdf"
          "application/rtf"
        ];

        "thunar.desktop" = [
          "inode/directory"
          "inode/mount-point"
        ];
      };
  };
}
