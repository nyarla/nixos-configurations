{
  stdenv,
  fetchurl,
  cudatoolkit,
  cmake,
  pkgconfig,
}:
stdenv.mkDerivation rec {
  pname = "xmrig-cuda";
  version = "v.6.17.0";
  src = fetchurl {
    url = "https://github.com/xmrig/xmrig-cuda/archive/refs/tags/v6.17.0.tar.gz";
    sha256 = "0r2z4bv3l119z22qm5ir34f9ggzm7113in2f9q150mcwv77pjab6";
  };

  cmakeFlags = [ "-DCUDA_LIB=${cudatoolkit}/lib/stubs/libcuda.so" ];

  buildInputs = [ cudatoolkit ];
  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp libxmrig-cuda.so $out/lib/
  '';
}
