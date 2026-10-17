{
  sources,

  stdenv,
  autoPatchelfHook,

  bzip2,
  carla,
  dbus,
  file,
  findutils,
  flac,
  libGL,
  libcap,
  libglvnd,
  libjack2,
  libogg,
  libopus,
  libsndfile,
  libvorbis,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  patchelf,
  pkg-config,
  qt5,
  wine,
  zstd,
}:
stdenv.mkDerivation {
  pname = "ildaeil";
  version = "2026-02-22";
  src = sources.Ildaeil;

  nativeBuildInputs = [
    findutils
    pkg-config
    patchelf
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    bzip2
    carla
    dbus
    file
    flac
    libGL
    libcap
    libglvnd
    libjack2
    libogg
    libopus
    libsndfile
    libvorbis
    libx11
    libxcursor
    libxext
    libxrandr
    zstd
  ];

  patches = [ ./nixos.patch ];

  postPatch = ''
    cd carla
    export carla=${carla}
    export wine=${wine}

    substituteAllInPlace source/jackbridge/Makefile
    substituteAllInPlace source/modules/dgl/Makefile
    substituteAllInPlace source/backend/CarlaStandalone.cpp
    substituteAllInPlace source/backend/engine/CarlaEngineJack.cpp
    cd ..

    substituteAllInPlace plugins/Common/IldaeilPlugin.cpp
    patchShebangs --build dpf/utils
  '';

  installFlags = [ "PREFIX=$(out)" ];
  makeFlags = [ "USE_SYSTEM_CARLA_BINS=true" ];

  preFixup = ''
    patchelf --add-needed libjack.so.0 $out/bin/Ildaeil
    find $out/lib -type f -name '*.so' -exec patchelf --add-needed libjack.so.0 {} \;
    find $out/lib -type f -name '*.clap' -exec patchelf --add-needed libjack.so.0 {} \;
  '';
}
