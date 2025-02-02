{
  stdenv,
  fetchFromGitHub,
  lib,
  runCommand,
  binutils,
  cmake,
  findutils,
  pkg-config,
  python3,
  alsa-lib,
  atk,
  boost178,
  cairo,
  curlFull,
  freetype,
  gdk-pixbuf,
  glib,
  graphviz,
  gtk3,
  gtkmm3,
  harfbuzz,
  ladspa-sdk,
  libGLU,
  libappindicator-gtk3,
  libdatrie,
  libdbusmenu,
  libepoxy,
  libjack2,
  libjpeg_turbo,
  libpng,
  libselinux,
  libsepol,
  libsysprof-capture,
  libthai,
  libxkbcommon,
  pango,
  pcre,
  pcre2,
  sqlite,
  util-linux,
  webkitgtk,
  xorg,
  zlib,
  vst2-sdk,
}:
let
  deps = fetchFromGitHub {
    owner = "apohl79";
    repo = "audiogridder-deps";
    rev = "6a7a41c06b9ca9d4a260febe79ee1f6e96618e0a";
    sha256 = "sha256-ESgeLkX/CQPY4/x3yl+H0OdpM9uc2z6dh4vMzcvXTR8=";
  };

  sdks = runCommand "ag-sdks" { } ''
    mkdir -p $out/vstsdk2.4
    cp -r ${vst2-sdk}/* $out/vstsdk2.4/
  '';

  boost178Static = boost178.override {
    enableShared = false;
    enableStatic = true;
  };
in
stdenv.mkDerivation rec {
  pname = "audiogridder-modded";
  version = "1.2.0-mod";

  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "audiogridder-modded";
    rev = "dc01e87a00b2de7f30a8d65628ceac7e4292661f";
    hash = "sha256-DdCpULUVTclcRBbTinE6cOx1jDg1Hst21DRkb3CCru8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    findutils
    binutils
  ];
  buildInputs =
    [
      alsa-lib
      atk
      boost178Static
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
      libdatrie.dev
      libdatrie.out
      libdbusmenu
      libepoxy.dev
      libepoxy.out
      libjack2
      libjpeg_turbo
      libpng
      libselinux.dev
      libselinux.out
      libsepol.dev
      libsepol.out
      libsysprof-capture
      libthai.dev
      libthai.out
      libxkbcommon.dev
      libxkbcommon.out
      pango
      pcre.dev
      pcre.out
      pcre2.dev
      pcre2.out
      sqlite.dev
      sqlite.out
      util-linux.dev
      util-linux.out
      webkitgtk
      zlib
    ]
    ++ (with xorg; [
      libX11
      libXcomposite
      libXcursor
      libXdmcp.dev
      libXdmcp.out
      libXext
      libXinerama
      libXrandr
      libXrender
      libXtst
      libxcb
    ]);

  libPath = lib.makeLibraryPath (
    buildInputs
    ++ [
      stdenv.cc.cc
      stdenv.cc.libc
    ]
  );

  postPatch = ''
    export binutils=${binutils}

    substituteAllInPlace CMakeLists.txt
    substituteAllInPlace Plugin/Source/PluginProcessor.cpp
    substituteAllInPlace Server/Source/App.cpp
    substituteAllInPlace Server/Source/ProcessorClient.cpp
    substituteAllInPlace Server/Source/Server.cpp
  '';

  cmakeFlags = [
    "-DAG_DEPS_ROOT=${deps}/linux-x86_64"
    "-DAG_SDKS_ROOT=${sdks}"
    "-DAG_VST2_PLUGIN_ENABLED=ON"
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

  fixupPhase = ''
    for exe in $(ls $out/bin); do
      patchelf --set-rpath "${libPath}" $out/bin/$exe
    done

    find $out/lib -type f -name '*.so' -exec patchelf --set-rpath "${libPath}" {} \;
  '';
}
