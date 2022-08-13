{ stdenv, fetchFromGitHub, wrapGAppsHook, pkgconfig, meson, ninja, gtk3, glib
, gtk-layer-shell, json_c }:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "git";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    rev = "794b92c92c03e4d058119e4554d2fba9540de7c7";
    sha256 = "1n01wwl5vpw075kr97qg0xn2sclb1g82q7z4w4jcnq7hcmwsl50l";
  };

  postPatch = ''
    sed -i 's|gio/gdesktopappinfo.h|gio-unix-2.0/gio/gdesktopappinfo.h|' src/scaleimage.c
  '';

  buildInputs = [ gtk3 gtk-layer-shell json_c glib.dev ];
  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook ];
}
