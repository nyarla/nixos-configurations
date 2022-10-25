{ stdenv, fetchFromGitHub, fetchzip, pkg-config, cmake, alsa-lib, curlFull
, doxygen, freetype, glib, graphviz, gtk3, ladspa-sdk, libjack2, libjpeg_turbo
, libpng, pcre, python3, webkitgtk, zlib, xorg, libGLU, juce-framework, lib }:
stdenv.mkDerivation rec {
  pname = "dexed";
  version = "git";

  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    rev = "9e01c0cbb1ff68297b180ffdeee0b5fb09af7e56";
    fetchSubmodules = true;
    sha256 = "sha256-4x8lgq0j50DxD1H5TKmnRIFN+Yotlk/f0CurTuShklA=";
  };

  postUnpack = ''
    mkdir -p source/assets/JUCE
    cp -R ${juce-framework.src}/* source/assets/JUCE
    chmod -R +w source/assets/JUCE

    cp ${juce-framework}/bin/Projucer source/assets/JUCE/Projucer
    chmod +x source/assets/JUCE/Projucer
  '';

  dontFixup = true;

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  nativeBuildInputs = [ cmake pkg-config doxygen python3 ];
  buildInputs = [
    alsa-lib
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

  libPath = lib.makeLibraryPath
    (buildInputs ++ [ curlFull.out stdenv.cc.cc stdenv.cc.libc ]);

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst3

    cp Source/Dexed_artefacts/Release/Standalone/Dexed \
      $out/bin

    chmod +x $out/bin/Dexed

    cp -R Source/Dexed_artefacts/Release/VST3/Dexed.vst3 \
      $out/lib/vst3/Dexed.vst3

    patchelf --set-rpath "${libPath}" $out/bin/Dexed
    patchelf --set-rpath "${libPath}" $out/lib/vst3/Dexed.vst3/Contents/x86_64-linux/Dexed.so
  '';
}
