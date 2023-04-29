{ stdenv, fetchFromGitHub, fetchzip, autoPatchelfHook, cmake, pkgconfig, alsaLib
, atk, boost173, cairo, curlFull, freetype, glib, graphviz, gdk-pixbuf, gtk3
, gtkmm3, harfbuzz, ladspa-sdk, libGLU, libappindicator-gtk3, libdbusmenu
, libjack2, libjpeg_turbo, libpng, pango, pcre, python3, webkitgtk, xorg, zlib
}:
let
  JUCE = fetchFromGitHub {
    owner = "apohl79";
    repo = "JUCE";
    rev = "05ca58e0c451b858ec0e224ffb1db178f0442b54";
    sha256 = "sha256-ZSOTncJu0G2HKREL1fafy1p7yPU0A+qIT+LO2pAdY3U=";
  };

  deps = fetchFromGitHub {
    owner = "apohl79";
    repo = "audiogridder-deps";
    rev = "6a7a41c06b9ca9d4a260febe79ee1f6e96618e0a";
    sha256 = "sha256-ESgeLkX/CQPY4/x3yl+H0OdpM9uc2z6dh4vMzcvXTR8=";
  };

  vst2sdk = fetchzip {
    url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
    sha256 = "sha256-6eDJYGfuVczOTaZNUYa/dLEoCzl6Ysi1I1NrxuN2mPQ=";
  };

  src = fetchFromGitHub {
    owner = "apohl79";
    repo = "audiogridder";
    rev = "4caed8e755d96ceafa655b271094437b62c68879";
    sha256 = "sha256-S2SuhKBX+b/onb2/jCMBzh37KM0oWTUpJcMjcQHTenE=";
  };

  boost173Static = boost173.override {
    enableShared = false;
    enableStatic = true;
  };
in stdenv.mkDerivation rec {
  pname = "audiogridder";
  version = "git";

  inherit src;

  dontStrip = true;

  nativeBuildInputs = [ cmake pkgconfig python3 autoPatchelfHook ];
  buildInputs = [
    alsaLib
    atk
    boost173Static
    cairo
    curlFull
    curlFull.dev
    freetype
    gdk-pixbuf
    glib
    glib.dev
    graphviz
    gtk3
    gtk3.dev
    gtkmm3
    gtkmm3.dev
    harfbuzz
    ladspa-sdk
    libGLU
    libappindicator-gtk3
    libappindicator-gtk3.dev
    libdbusmenu
    libjack2
    libjpeg_turbo
    libpng
    pango
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
    libXtst
    libxcb
  ]);

  preConfigure = ''
    rm -rf JUCE
    ln -sf ${JUCE} JUCE

    sed -i "s|path << \"/local/share/audiogridder/AudioGridderPluginTray\"|path = \"$out/bin/AudioGridderPluginTray\"|" \
      Plugin/Source/PluginProcessor.cpp
    sed -i "s|lhs.getNameAndID().compare(rhs.getNameAndID())|lhs.getHostAndID().compare(rhs.getHostAndID())|" \
      Common/Source/ServiceReceiver.cpp
    sed -i "s|/usr/bin/strip|# |g" CMakeLists.txt
  '';

  cmakeFlags = [
    "-DAG_SDKS_ROOT=${deps}/linux-x86_64"
    "-DAG_VST2_PLUGIN_ENABLED=ON"
    "-DAG_VST2_SDK=${vst2sdk}"
    "-DAG_WITH_PLUGIN=ON"
    "-DAG_WITH_SERVER=ON"
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
    "-DFFMPEG_ROOT=${deps}/linux-x86_64"
    "-DWEBP_ROOT=${deps}/linux-x86_64"
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst
    mkdir -p $out/lib/vst3
    mkdir -p $out/share/audiogridder/images

    cp -R ../Server/Resources/* $out/share/audiogridder/images

    for fn in Fx Inst Midi ; do
      mv Plugin/AudioGridder''${fn}_artefacts/Release/VST3/* $out/lib/vst3/
      mv Plugin/AudioGridder''${fn}_artefacts/Release/VST/* $out/lib/vst/
    done

    cp PluginTray/AudioGridderPluginTray_artefacts/Release/AudioGridderPluginTray $out/bin/
    cp Server/AudioGridderServer_artefacts/Release/AudioGridderServer $out/bin/

    chmod +x $out/bin/*
  '';
}
