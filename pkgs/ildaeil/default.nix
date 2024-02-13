{ stdenv, fetchFromGitHub, autoPatchelfHook, pkg-config, patchelf, qt5
, findutils, bzip2, carla, dbus, file, flac, libGL, libcap, libglvnd, libjack2
, libogg, libopus, libsndfile, libvorbis, xorg, zstd }:
stdenv.mkDerivation rec {
  pname = "ildaeil";
  version = "2024-02-13";
  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "Ildaeil";
    rev = "8d65bc07b6ba2485eded9bc829650ca03409672a";
    hash = "sha256-gT5ZhZHHe3eiQtIJ/IJPR9TxmCzt7hqaaWIP/6gTy6A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs =
    [ findutils pkg-config patchelf autoPatchelfHook qt5.wrapQtAppsHook ];

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
    chmod +w carla
  '';

  patches = [ ./nixos.patch ];

  postPatch = ''
    cd carla
    ${carla.postPatch} 
    cd ..

    sed 's|/usr/lib/carla|${carla}/lib/carla|g' plugins/Common/IldaeilPlugin.cpp
    sed 's|/usr/share/carla|${carla}/share/carla|g' plugins/Common/IldaeilPlugin.cpp

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
