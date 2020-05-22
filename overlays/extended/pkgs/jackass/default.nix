{ multiStdenv, fetchzip, fetchurl, pkgsi686Linux, libjack2, wineWowPackages, xorg, gnused }:
let
  vst2sdk = fetchzip {
    url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
    sha256 = "1x4qfviwcssk4fswhqks745jicblpy352kd69p7cqmgfcxhckq79";
  };
in
multiStdenv.mkDerivation rec {
  name = "Jackass-${version}";
  version = "v1.1";
  src = fetchurl {
    url = "https://github.com/falkTX/JackAss/archive/v1.1.tar.gz";
    sha256 = "1wrkrzr1k0px0swv477pm0gbz13vr10q7m9z0dpz0s7vg6d3y2fd";
  };

  nativeBuildInputs = [ gnused ];

  buildInputs = [
    libjack2
    pkgsi686Linux.libjack2
    wineWowPackages.staging
    xorg.libpthreadstubs
  ];

  postUnpack = ''
    cp -R ${vst2sdk}/* "JackAss-1.1"/vstsdk2.4/
  '';

  patchPhase = ''
    chmod -R +w vstsdk2.4
    sed -i 's|VST_EXPORT |VST_EXPORT VSTCALLBACK |g' vstsdk2.4/public.sdk/source/vst2.x/vstplugmain.cpp
  '';

  buildPhase = ''
    mkdir -p $out/lib/vst/JackAss

    make linux \
      CXXFLAGS=-I${libjack2}/include \
      LDFLAGS="-L${libjack2}/lib -ljack"
    cp JackAss.so $out/lib/vst/JackAss/
    make clean

    make wine32
      CXXFLAGS=-I${pkgsi686Linux.libjack2}/include \
      LDFLAGS="-L${pkgsi686Linux.libjack2}/lib -ljack"
    cp JackAss*.dll $out/lib/vst/JackAss/
    make clean

    make wine64 \
      CXXFLAGS=-I${libjack2}/include \
      LDFLAGS="-L${libjack2}/lib -ljack"
    cp JackAss*.dll $out/lib/vst/JackAss/
    make clean

  '';

  installPhase = "true";
}
