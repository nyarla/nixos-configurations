{
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  pkg-config,
  patchelf,
  qt5,
  findutils,
  bzip2,
  carla,
  dbus,
  file,
  flac,
  libGL,
  libcap,
  libglvnd,
  libjack2,
  libogg,
  libopus,
  libsndfile,
  libvorbis,
  wine,
  xorg,
  zstd,
}:
stdenv.mkDerivation rec {
  pname = "ildaeil";
  version = "2024-04-27";
  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "Ildaeil";
    rev = "ce4c3e24a2da459362eeb723f5e4568048ec9d72";
    hash = "sha256-cu/Yy6UszwOlXpdAYF63aIyvCGrjhWyNdFlTMWm6tsw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    findutils
    pkg-config
    patchelf
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    bzip2.dev
    carla
    dbus.dev
    file.dev
    flac.dev
    libGL.dev
    libcap.dev
    libglvnd.dev
    libjack2
    libogg.dev
    libopus.dev
    libsndfile.dev
    libvorbis.dev
    xorg.libX11.dev
    xorg.libXcursor.dev
    xorg.libXext.dev
    xorg.libXrandr.dev
    zstd.dev
  ];

  postUnpack = ''
    rm carla -rf
    cp -R ${carla.src} carla
    chmod -R +w carla
  '';

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
