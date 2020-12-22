{ multiStdenv, pkgs, pkgsi686Linux, fetchzip, fetchFromGitHub, meson, ninja
, pkgconfig, cmake, wineWowPackages, patchelf }:
let
  bitsery = fetchzip {
    url =
      "https://github.com/fraillt/bitsery/archive/d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e.zip";
    sha256 = "0r7v2yfb2hqn8jxz33qrh8hvbwqlv89wvsdak40v3y18iqqivd92";
  };
  tomlplusplus = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "v1.2.5";
    sha256 = "1sv8yrsk4ggdnp3z3yfb4qjb525bxlm5q7k666yjjqi6cnwwx2kw";
    fetchSubmodules = true;
  };
  dependences = ps: {
    boostStatic = ps.boost.override {
      enableStatic = true;
      enableShared = false;
    };
    libxcb = ps.xorg.libxcb;
  };
  i686 = dependences pkgsi686Linux;
  x86_64 = dependences pkgs;
in multiStdenv.mkDerivation rec {
  pname = "yabridge";
  version = "git";
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "yabridge";
    rev = "9ecb65664ce39bc851bc3661e0d127c2dd480df0";
    sha256 = "1gw66s1whngrcpslgsxkzn5khjaanzwpgvas0snbffw7arlg26c3";
  };

  patches = [ ./build_on_nixos.patch ];

  postPatch = ''
    sed -i 's|@XCB@|${multiStdenv.lib.getLib i686.libxcb}|' meson.build
    sed -i 's|@BOOST@|${multiStdenv.lib.getLib i686.boostStatic}|' meson.build
    sed -i 's|build_tests = get_option|build_tests = false and get_option|' subprojects/tomlplusplus/meson.build
    sed -i 's|build_examples = get_option|build_examples = false and get_option|' subprojects/tomlplusplus/meson.build
  '';

  mesonFlags = [ "--cross-file cross-wine.conf" "-Duse-bitbridge=true" ];

  postUnpack = ''
    mkdir -p source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e
    cp -R ${bitsery}/* source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e/
    tar -xvf source/subprojects/bitsery-patch.tar.xz -C source/subprojects

    mkdir -p source/subprojects/tomlplusplus
    cp -R ${tomlplusplus}/* source/subprojects/tomlplusplus/
  '';

  preConfigure = ''
    export BOOST_INCLUDEDIR="${
      multiStdenv.lib.getDev x86_64.boostStatic
    }/include"
    export BOOST_LIBRARYDIR="${multiStdenv.lib.getLib x86_64.boostStatic}/lib"
    export PKG_CONFIG_LIBDIR="${
      multiStdenv.lib.getDev i686.libxcb
    }/lib/pkgconfig:${multiStdenv.lib.getDev x86_64.libxcb}/lib/pkgconfig"
    export PATH="${pkgs.gcc_multi}/bin:$PATH"
    export WINEPREFIX=$(pwd)/wineprefix
  '';

  nativeBuildInputs = [ meson ninja pkgconfig cmake patchelf ];

  buildInputs = [
    wineWowPackages.staging
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
    patchelf \
      --set-rpath "${i686.libxcb}/lib:${wineWowPackages.staging}/lib:${pkgsi686Linux.stdenv.cc.cc.lib}/lib" \
      $out/bin/yabridge-group-32.exe.so
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst-wine

    cp yabridge-host.exe $out/bin/
    cp yabridge-host.exe.so $out/bin/
    cp yabridge-group.exe $out/bin/
    cp yabridge-group.exe.so $out/bin/

    cp libyabridge.so $out/lib/vst-wine/

    cp yabridge-host-32.exe $out/bin/
    cp yabridge-host-32.exe.so $out/bin/
    cp yabridge-group-32.exe $out/bin/
    cp yabridge-group-32.exe.so $out/bin/
  '';
}
