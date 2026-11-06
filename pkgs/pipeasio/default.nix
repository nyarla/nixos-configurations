{
  sources,

  stdenv,
  pkgsCross,
  cmake,
  pkg-config,

  libarchive,
  pipewire,
  qt6,
  wine,
  yaml-cpp,
}:
stdenv.mkDerivation {
  pname = "pipeasio";
  inherit (sources.pipeasio) version;

  src = sources.pipeasio;

  postPatch = ''
    substituteInPlace pipeasio-register \
      --replace-fail "\''${PIPEASIO_PREFIX:+\''${PIPEASIO_PREFIX}/lib/wine}" "''${out}/lib/wine"  
  '';

  cmakeFlags = [
    "-DIPEASIO_WINE_INSTALL_ROOT=$(out)"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    pkgsCross.mingwW64.buildPackages.gcc
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libarchive
    pipewire
    qt6.qtbase
    wine
    yaml-cpp
  ];
}
