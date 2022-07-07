{ stdenv, fetchFromGitHub, fetchzip, pkgconfig, cmake, alsaLib, curlFull
, doxygen, freetype, glib, graphviz, gtk3, ladspa-sdk, libjack2, libjpeg_turbo
, libpng, pcre, python3, webkitgtk, zlib, xorg, libGLU, JUCE, lib }:
let
  payload = fetchzip {
    url = "https://github.com/juce-framework/JUCE/archive/refs/tags/6.1.6.zip";
    sha256 = "1pxm5ly4480xh7z1xljmsd27qyyfkjflf66g6gi6rcvdh976vzww";
  };
in stdenv.mkDerivation rec {
  pname = "dexed";
  version = "git";

  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    rev = "1df9a58780fd5853ed79bf01aacdb1d7dea69c79";
    fetchSubmodules = true;
    sha256 = "1s3pw1l94wk5qqydzfhrzshw89m89vinjwwzfrccxmy4pa3gpjzs";
  };

  dontUseCmakeConfigure = true;
  dontFixup = true;

  postUnpack = ''
    mkdir -p source/assets/JUCE
    cp -R ${payload}/* source/assets/JUCE
    chmod +w source/assets/JUCE

    cp ${JUCE}/bin/Projucer source/assets/JUCE/Projucer
    chmod +x source/assets/JUCE/Projucer
  '';

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  nativeBuildInputs = [ cmake pkgconfig doxygen python3 ];
  buildInputs = [
    alsaLib
    curlFull.dev
    freetype
    glib.dev
    graphviz
    gtk3
    ladspa-sdk
    libGLU
    libjack2
    libjpeg_turbo
    libpng
    pcre
    webkitgtk
    zlib
  ] ++ (with xorg; [
    libX11
    libXcomposite
    libXcursor
    libXext
    libXinerama
    libXrandr
    libXrender
  ]);

  preConfigure = ''
    bash scripts/projuce.sh
  '';

  libPath = lib.makeLibraryPath
    (buildInputs ++ [ curlFull.out stdenv.cc.cc stdenv.cc.libc ]);

  buildPhase = ''
    export CONFIG=Release
    cd Builds/Linux
    make VST3 Standalone

    patchelf --set-rpath "${libPath}" build/Dexed
    patchelf --set-rpath "${libPath}" build/Dexed.vst3/Contents/x86_64-linux/Dexed.so
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/Dexed $out/bin/Dexed
    chmod +x $out/bin/*

    mkdir -p $out/lib/vst3/Dexed.vst3
    cp -R build/Dexed.vst3/* $out/lib/vst3/Dexed.vst3/
  '';
}
