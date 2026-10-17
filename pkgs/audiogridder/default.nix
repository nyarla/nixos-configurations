{
  sources,

  lib,
  runCommand,

  stdenv,
  stdenvNoCC,

  cmake,
  pkg-config,

  alsa-lib,
  atk,
  binutils,
  boost178,
  cairo,
  curlFull,
  findutils,
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
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdmcp,
  libxext,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxtst,
  pango,
  pcre,
  pcre2,
  python3,
  sqlite,
  util-linux,
  vst2-sdk,
  webkitgtk_4_1,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "audiogridder-modded";
  version = "1.2.0-mod";

  src = sources.audiogridder-modded;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    findutils
    binutils
  ];
  buildInputs =
    let
      boost178Static = boost178.override {
        enableShared = false;
        enableStatic = true;
      };
    in
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
      libdatrie
      libdbusmenu
      libepoxy
      libjack2
      libjpeg_turbo
      libpng
      libselinux
      libsepol.dev
      libsepol.out
      libsysprof-capture
      libthai
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdmcp.dev
      libxdmcp.out
      libxext
      libxinerama
      libxkbcommon
      libxrandr
      libxrender
      libxtst
      pango
      pcre
      pcre2
      sqlite
      util-linux
      webkitgtk_4_1
      zlib
    ];

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

  cmakeFlags =
    let
      sdks = runCommand "ag-sdks" { } ''
        mkdir -p $out/vstsdk2.4
        cp -r ${vst2-sdk}/* $out/vstsdk2.4/
      '';

      deps = stdenvNoCC.mkDerivation {
        pname = "audiogridder-deps";
        version = "main";

        src = sources.audiogridder-deps;
        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall 
        '';
      };
    in
    [
      "-DCMAKE_BUILD_TYPE=Release"

      "-DAG_DEPS_ROOT=${deps}/linux-x86_64"
      "-DFFMPEG_ROOT=${deps}/linux-x86_64"
      "-DWEBP_ROOT=${deps}/linux-x86_64"
      "-DAG_SDKS_ROOT=${sdks}"

      "-DAG_VST2_PLUGIN_ENABLED=ON"
      "-DAG_WITH_PLUGIN=ON"
      "-DAG_WITH_SERVER=ON"

      "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
      "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"

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
