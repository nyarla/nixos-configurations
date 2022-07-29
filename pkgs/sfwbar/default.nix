{ stdenv, fetchFromGitHub, wrapGAppsHook, pkgconfig, meson, ninja, gtk3, glib
, gtk-layer-shell, json_c }:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "git";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    rev = "badda6ebee5e06935a67881ccfc0e97564e247de";
    sha256 = "0nfhsx3ph92z1qz56rd856ny9g0k3bsagx01j0dbrykb0gg8j1zh";
  };

  postPatch = ''
    sed -i 's|gio/gdesktopappinfo.h|gio-unix-2.0/gio/gdesktopappinfo.h|' src/scaleimage.c
  '';

  buildInputs = [ gtk3 gtk-layer-shell json_c glib.dev ];
  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook ];
}
