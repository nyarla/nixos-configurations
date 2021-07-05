{ gcc8Stdenv, fetchgit, cmake, xorg, gettext, pkgconfig, wineWowPackages }:
gcc8Stdenv.mkDerivation rec {
  pname = "violin";
  version = "git";
  src = fetchgit {
    url = "https://gitlab.com/aclex/violin";
    rev = "ef6160fdec8bea05d64cb2807b908a05300bd858";
    sha256 = "16lz23kirgnwcrjyxzngp92prbfmfbksd8abc5d1d23dvfw1avfm";
    fetchSubmodules = true;
  };

  patches = [ ./cmake.patch ];

  postPatch = ''
    sed -i "s|/var/log/violin.log|/tmp/violin.log|" src/log.cpp 
    sed -i 's|SYSCONFDIR|"/home/nyarla/.config"|' src/config.cpp
  '';

  nativeBuildInputs = [
    cmake
    pkgconfig
    gettext

  ];

  buildInputs = [
    xorg.libxcb.dev
    xorg.libXau
    xorg.libXdmcp
    xorg.libpthreadstubs
    wineWowPackages.staging
  ];
}
