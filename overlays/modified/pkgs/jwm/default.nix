{ stdenv
, fetchurl
, pkgconfig
, gettext
, which
, xorg
, libX11
, libXext
, libXinerama
, libXpm
, libXft
, libXau
, libXdmcp
, libXmu
, libpng
, libjpeg
, expat
, xorgproto
, librsvg
, freetype
, fontconfig
}:

stdenv.mkDerivation rec {
  pname = "jwm";
  version = "git";

  src = fetchurl {
    url = "https://joewing.net/projects/jwm/releases/jwm-2.3.7.tar.xz";
    sha256 = "09jkcs5svrsdq6f14vf2q13dscdy7zdmwi3miv69xkm4ydfjypbl";
  };

  nativeBuildInputs = [ pkgconfig gettext which ];

  buildInputs = [
    libX11
    libXext
    libXinerama
    libXpm
    libXft
    xorg.libXrender
    libXau
    libXdmcp
    libXmu
    libpng
    libjpeg
    expat
    xorgproto
    librsvg
    freetype
    fontconfig
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
