{ multiStdenv, fetchurl, wineWowPackages, xorg, gnused }:
multiStdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src     = fetchurl {
    url = "https://github.com/osxmidi/LinVst/archive/master.tar.gz";
    sha256 = "0yxx4aqbhp95sgn1ph817yabk8wbd0s4aympgdfr5a6w7gix5s72";
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
    sed -i "s!./vst!$out/lib/vst-wine!" Makefile
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
  '';
}
