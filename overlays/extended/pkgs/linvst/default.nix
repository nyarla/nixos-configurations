{ stdenv, fetchurl, wineWowPackages, xorg, gnused }:
stdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src     = fetchurl {
    url = "https://github.com/osxmidi/LinVst/archive/master.tar.gz";
    sha256 = "1hhwrzc9s91k2ir3gag6ibcjybvxr2ai5mw7gk4fnc7n7c5ghfma";
  };

  nativeBuildInputs = [
    wineWowPackages.staging gnused
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
