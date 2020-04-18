{ stdenv, fetchzip, fetchFromGitHub, meson, ninja, pkgconfig, cmake, wineWowPackages, boost, xorg }:
let
  bitsery = fetchzip {
    url = "https://github.com/fraillt/bitsery/archive/d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e.zip";
    sha256 = "0r7v2yfb2hqn8jxz33qrh8hvbwqlv89wvsdak40v3y18iqqivd92";
  };
in stdenv.mkDerivation rec {
  pname = "yabridge";
  version = "git";
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "yabridge";

    rev = "f56b8b74b1db099377e566481f9685207c21526d";
    sha256 = "0qijgyyll0r21y30vzgbbvxzxrqj5sbd7jcj3448p7gq5d5a0dzl";
  };

  postUnpack = ''
    mkdir -p source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e
    cp -R ${bitsery}/* source/subprojects/bitsery-d24dfe14f5a756c0f8ad3d56ae6949ecc2c99b2e/
    tar -xvf source/subprojects/bitsery-patch.tar.xz -C source/subprojects 
  '';

  nativeBuildInputs = [
    meson ninja wineWowPackages.staging pkgconfig cmake
  ];

  mesonFlags = [ "--cross-file cross-wine64.conf" ];

  buildInputs = [
    boost xorg.libxcb xorg.xcbutilwm
  ];

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst-wine

    cp yabridge-host.exe $out/bin/
    cp yabridge-host.exe.so $out/bin/
    cp libyabridge.so $out/lib/vst-wine/
  '';
}
