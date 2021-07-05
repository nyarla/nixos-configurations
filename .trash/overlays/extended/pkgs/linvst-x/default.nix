{ multiStdenv, fetchFromGitHub, wineWowPackages, xorg, gnused }:
multiStdenv.mkDerivation rec {
  name = "linvst-x";
  version = "git";

  src = fetchFromGitHub {
    owner = "osxmidi";
    repo = "LinVst-X";
    rev = "d462296285e3938bc227357ecbd240863968f5d2";
    sha256 = "0b6381an8pphm937kk54jifxzjd0px3g0bnh553sv8av7hg5ifpp";
  };

  nativeBuildInputs = [ wineWowPackages.staging gnused ];

  buildInputs = [ xorg.libX11 ];

  patchPhase = ''
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst-wine!" Makefile
    sed -i "s!/usr/bin!$out/bin!g" remotepluginclient.cpp
    sed -i "s!/usr/bin!$out/bin!g" lin-vst-server-all.cpp
    sed -i "s!/usr/bin!$out/bin!g" lin-vst-server-mplugin-library.cpp
    sed -i "s!/usr/bin!$out/bin!g" lin-vst-server-library.cpp
    sed -i "s!/usr/bin!$out/bin!g" lin-vst-server.cpp
  '';
}
