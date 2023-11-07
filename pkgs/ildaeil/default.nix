{ stdenv, fetchFromGitHub, pkg-config, patchelf, autoPatchelfHook, findutils
, bzip2, carla, dbus, file, flac, libGL, libcap, libglvnd, libjack2, libogg
, libopus, libsndfile, libvorbis, xorg, zstd }:
stdenv.mkDerivation rec {
  pname = "ildaeil";
  version = "2023-10-07";
  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "Ildaeil";
    rev = "0044a9cca7435953d746ccbfaad27aa98e590d96";
    hash = "sha256-A+2qLqGST/ZSll6Y5GTIj7dLNGQ4/966/5kiNJyi9uY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ findutils pkg-config patchelf autoPatchelfHook ];

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

  preBuild = ''
    patchShebangs --build dpf/utils
  '';

  patches = [ ./nixos-path.patch ];

  postPatch = ''
    cd carla
    ${carla.postPatch}
    cd ../

    export carla=${carla}
    substituteAllInPlace plugins/Common/IldaeilPlugin.cpp
  '';

  installFlags = [ "PREFIX=$(out)" ];
  makeFlags = [ "USE_SYSTEM_CARLA_BINS=true" ];

  preFixup = ''
    patchelf --add-needed libjack.so.0 $out/bin/Ildaeil
    find $out/lib -type f -name '*.so' -exec patchelf --add-needed libjack.so.0 {} \;
    find $out/lib -type f -name '*.clap' -exec patchelf --add-needed libjack.so.0 {} \;
  '';
}
