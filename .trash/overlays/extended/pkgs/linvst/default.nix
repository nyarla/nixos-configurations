{ stdenv, fetchFromGitHub, wineWowPackages, xorg, gnused }:
stdenv.mkDerivation rec {
  name = "linvst";
  version = "git";

  src = fetchFromGitHub {
    owner = "osxmidi";
    repo = "LinVst";
    rev = "e0c8d554673c09e250f032b3ca6befaafc4ac38f";
    sha256 = "0b61r8fhyin0bhwgja3mqsagqmmsw67r188k19pc06di8nf2xf6a";
  };

  nativeBuildInputs = [ wineWowPackages.staging gnused ];

  buildInputs = [ xorg.libX11 ];

  patchPhase = ''
    rm Makefile
    mv Makefile-Bitwig Makefile
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst-wine!" Makefile
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
  '';
}
