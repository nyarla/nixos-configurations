{ multiStdenv, fetchurl, wineWowPackages, xorg, gnused }:
multiStdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src     = fetchurl {
    url = "https://github.com/osxmidi/LinVst/archive/master.tar.gz";
    sha256 = "1wsxvzhgdfw8f0mk758ky2rp8wmh0662m0q8bf2bfw2jl6jg9vaf";
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
