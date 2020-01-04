{ stdenv, fetchurl, pkgconfig, lzma, xar }:
stdenv.mkDerivation rec {
  name    = "pbzx";
  version = "v1.0.2";
  src     = fetchurl {
    url     = "https://github.com/NiklasRosenstein/pbzx/archive/v1.0.2.tar.gz";
    sha256  = "147xnhi0x488cjhryi641kyxpiplhk4m5fmz3d771bkhvkwkrnrk";
  };

  buildInputs = [
    lzma xar pkgconfig
  ];

  buildPhase = ''
    ${stdenv.cc}/bin/gcc -o pbzx pbzx.c $(pkg-config liblzma --cflags --libs) -lxar
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp pbzx $out/bin/pbzx
  '';
}
