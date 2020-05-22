{ stdenv, fetchurl, wineWowPackages, xorg, gnused }:
stdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src = fetchurl {
    url = "https://github.com/osxmidi/LinVst/archive/master.tar.gz";
    sha256 = "1jfsxxmg5nb0y6x760phdw7b86i8jzprgwmfcdchdq2qvsz8pjc7";
  };

  nativeBuildInputs = [
    wineWowPackages.staging
    gnused
  ];

  buildInputs = [
    xorg.libX11
  ];

  patchPhase = ''
    rm Makefile
    mv Makefile-Bitwig Makefile
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst-wine!" Makefile
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
  '';
}
