{ multiStdenv, fetchurl, wineWowPackages, xorg, gnused }:
multiStdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src     = fetchurl {
    url = "https://github.com/osxmidi/LinVst/archive/master.tar.gz";
    sha256 = "14w24avlfy03zfw3d0v3c7qc0a37zzd89pi021aqdaf76mx5fyza";
  };
  
  nativeBuildInputs = [
    wineWowPackages.staging gnused
  ];

  buildInputs = [
    xorg.libX11
  ];

  patchPhase = ''
    rm Makefile
    mv Makefile-embed-6432 Makefile
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst!" Makefile
    sed -i "s!/usr/lib/x86_64-linux-gnu/wine-development!${wineWowPackages.staging}/include/wine!" Makefile
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
  '';
}
