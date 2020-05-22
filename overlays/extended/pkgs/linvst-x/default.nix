{ multiStdenv, fetchurl, wineWowPackages, xorg, gnused }:
multiStdenv.mkDerivation rec {
  name = "linvst-x";
  version = "git";

  src = fetchurl {
    url = "https://github.com/osxmidi/LinVst-X/archive/master.tar.gz";
    sha256 = "0jxcxhnacdf72fqdycghvv0a8c33l1jxrb0dvp93407zdfxls9pk";
  };

  nativeBuildInputs = [
    wineWowPackages.staging
    gnused
  ];

  buildInputs = [
    xorg.libX11
  ];

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
