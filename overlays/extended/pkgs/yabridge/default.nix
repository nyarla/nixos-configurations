{ multiStdenv, pkgs, pkgsi686Linux, fetchzip, fetchFromGitHub, meson, ninja, pkgconfig, cmake, wineWowPackages, patchelf }:
let
  bitsery = fetchzip {
    url = "https://github.com/fraillt/bitsery/archive/d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e.zip";
    sha256 = "0r7v2yfb2hqn8jxz33qrh8hvbwqlv89wvsdak40v3y18iqqivd92";
  };
  dependences = ps: {
    boostStatic = ps.boost.override { enableStatic = true; enableShared = false; };
    libxcb = ps.xorg.libxcb;
    glibc = ps.glibc;
  };
  i686 = dependences pkgsi686Linux;
  x86_64 = dependences pkgs;
in
multiStdenv.mkDerivation rec {
  pname = "yabridge";
  version = "git";
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "yabridge";
    rev = "e728dbe5a2262d9df931c93c651b053d7a80b5e5";
    sha256 = "1y8jxi1ndh9w3s6q4naqd00qhd3xqkjidmpcp8kw2xrfpf603g33";
  };

  patches = [
    ./build_on_nixos.patch
  ];

  postPatch = ''
    sed -i 's|@XCB@|${multiStdenv.lib.getLib i686.libxcb}|' meson.build
  '';

  mesonFlags = [ "--cross-file cross-wine.conf" "-Duse-bitbridge=true" ];

  postUnpack = ''
    mkdir -p source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e
    cp -R ${bitsery}/* source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e/
    tar -xvf source/subprojects/bitsery-patch.tar.xz -C source/subprojects 
  '';

  preConfigure = ''
    export BOOST_INCLUDEDIR="${multiStdenv.lib.getDev x86_64.boostStatic}/include"
    export BOOST_LIBRARYDIR="${multiStdenv.lib.getLib x86_64.boostStatic}/lib"
    export PKG_CONFIG_LIBDIR="${multiStdenv.lib.getDev i686.libxcb}/lib/pkgconfig:${multiStdenv.lib.getDev x86_64.libxcb}/lib/pkgconfig"
    export PATH="${pkgs.gcc_multi}/bin:$PATH"
  '';

  nativeBuildInputs = [
    meson
    ninja
    wineWowPackages.staging
    pkgconfig
    cmake
    patchelf
  ];

  buildInputs = [
    pkgs.gcc_multi

    x86_64.boostStatic
    x86_64.libxcb

    i686.boostStatic
    i686.libxcb
  ];

  postFixup = ''
    patchelf \
      --set-rpath "${i686.libxcb}/lib:${wineWowPackages.staging}/lib:${pkgsi686Linux.stdenv.cc.cc.lib}/lib" \
      $out/bin/yabridge-host-32.exe.so
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst-wine

    cp yabridge-host.exe $out/bin/
    cp yabridge-host.exe.so $out/bin/

    cp libyabridge.so $out/lib/vst-wine/

    cp yabridge-host-32.exe $out/bin/
    cp yabridge-host-32.exe.so $out/bin/
  '';
}
