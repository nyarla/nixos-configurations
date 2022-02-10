{ stdenv, fetchurl, cudatoolkit, cmake, pkgconfig }:
stdenv.mkDerivation rec {
  pname = "xmrig-cuda";
  version = "v.6.15.1";
  src = fetchurl {
    url =
      "https://github.com/xmrig/xmrig-cuda/archive/refs/tags/v6.15.1.tar.gz";
    sha256 = "1qaiz5risqbbnz34ifmh1rsj0gsp1ny64rlgr6f0hq8qhmjvhrm9";
  };

  cmakeFlags = [ "-DCUDA_LIB=${cudatoolkit}/lib/stubs/libcuda.so" ];

  buildInputs = [ cudatoolkit ];
  nativeBuildInputs = [ cmake pkgconfig ];

  installPhase = ''
    mkdir -p $out/lib
    cp libxmrig-cuda.so $out/lib/
  '';
}
