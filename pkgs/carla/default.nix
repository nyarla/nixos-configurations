{
  carla,
  glibc,
  pkgsCross,
  wine,
  multiStdenv,
  fetchFromGitHub,
}:
let
  pkgsMinGW = bit: if bit == 32 then pkgsCross.mingw32 else pkgsCross.mingwW64;

  mingw32 = pkgsMinGW 32;
  mingwW64 = pkgsMinGW 64;

  mcfgthreadsw32 = mingw32.windows.mcfgthreads.overrideAttrs (_: {
    dontDisableStatic = true;
  });
  mcfgthreadsW64 = mingwW64.windows.mcfgthreads.overrideAttrs (_: {
    dontDisableStatic = true;
  });
in
(carla.override { stdenv = multiStdenv; }).overrideAttrs (old: rec {
  version = "2024-04-27"; # keep same version of ildaeil
  src = fetchFromGitHub {
    inherit (old.src) owner repo;
    rev = "f980758afb6f614119c8c228f3c0d993d8144657";
    hash = "sha256-7laCsvMr5x7zknISffdBdFmkStxE2leKjtWLp+zkS9A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = old.nativeBuildInputs ++ [
    wine
    mingw32.buildPackages.gcc
    mingwW64.buildPackages.gcc
  ];

  buildInputs = old.buildInputs ++ [
    mcfgthreadsw32.dev
    mcfgthreadsW64.dev
  ];

  dontStrip = true;

  patches = [ ./nixos.patch ];

  postPatch =
    old.postPatch
    + ''
      export carla=$out
      export wine=${wine}

      substituteAllInPlace source/jackbridge/Makefile
      substituteAllInPlace source/modules/dgl/Makefile
      substituteAllInPlace source/backend/CarlaStandalone.cpp
      substituteAllInPlace source/backend/engine/CarlaEngineJack.cpp
    '';

  postBuild = ''
    make win32 \
      CC=i686-w64-mingw32-gcc \
      CXX=i686-w64-mingw32-g++ \
      CFLAGS="-I${mingw32.windows.mingw_w64_pthreads}/include -I${mcfgthreadsw32.dev}/include" \
      CXXFLAGS="-I${mingw32.windows.mingw_w64_pthreads}/include -I${mcfgthreadsw32.dev}/include" \
      LDFLAGS="-L${mingw32.windows.mingw_w64_pthreads}/lib -L${mcfgthreadsw32}/lib"

    make wine32 \
      CC="winegcc -m32" \
      CXX="winegcc -m32" \
      CFLAGS="-I${glibc.dev}/include" \
      CXXFLAGS="-I${glibc.dev}/include" \

    make win64 \
      CC=x86_64-w64-mingw32-gcc \
      CXX=x86_64-w64-mingw32-g++ \
      CFLAGS="-I${mingwW64.windows.mingw_w64_pthreads}/include -I${mcfgthreadsW64.dev}/include" \
      CXXFLAGS="-I${mingwW64.windows.mingw_w64_pthreads}/include -I${mcfgthreadsW64.dev}/include" \
      LDFLAGS="-L${mingwW64.windows.mingw_w64_pthreads}/lib -L${mcfgthreadsW64}/lib"

    make wine64 \
      CC="winegcc" \
      CXX="winegcc" \
      CFLAGS="-I${glibc.dev}/include" \
      CXXFLAGS="-I${glibc.dev}/include"
  '';
})
