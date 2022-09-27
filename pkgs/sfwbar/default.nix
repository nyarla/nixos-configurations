{ stdenv, fetchFromGitHub, wrapGAppsHook, pkg-config, meson, ninja, gtk3, glib
, gtk-layer-shell, json_c }:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "git";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    rev = "ab683b986f06cfb1c6cd8c30a0f1fcbc3a2d81d4";
    sha256 = "08mjwq24z6y47ga9x8y0is4wngr2i5lq11vsfz1zl9fkc5pr526w";
  };

  postPatch = ''
    sed -i 's|gio/gdesktopappinfo.h|gio-unix-2.0/gio/gdesktopappinfo.h|' src/scaleimage.c
  '';

  buildInputs = [ gtk3 gtk-layer-shell json_c glib.dev ];
  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook ];
}
