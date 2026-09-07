{
  buildFHSEnv,
  lib,
  python3,
}:
buildFHSEnv {
  name = "gimp-shell";
  targetPkgs =
    p: with p; [
      babl
      cairo
      gdk-pixbuf
      gegl
      gexiv2
      gimp3
      gobject-introspection
      harfbuzz
      pango
      python3
      python3.pkgs.pygobject3
    ];
  runScript = "bash";
  profile = ''
    export PYTHONPATH=/usr/lib/python${lib.versions.majorMinor python3.version}/site-packages
    export GI_TYPELIB_PATH=/usr/lib/girepository-1.0
  '';
}
