{
  carla,
  python312,
  glibc,
  pkgsCross,
  wine,
  multiStdenv,
  fetchFromGitHub,
  fetchpatch,
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

  # temporary workaround for fix to build error of pyliblo3
  python3Packages =
    (python312.override {
      packageOverrides = _: prev: {
        pyliblo3 = prev.pyliblo3.overrideAttrs (_: rec {
          patches = [
            (fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/gesellkammer/pyliblo3/pull/15.patch";
              sha256 = "1mir24mzfmmrha5qf08hp7d2g1f47ykgr59j2ybjwvyy7fd2jmg0";
            })
          ];
        });
      };
    }).pkgs;
in
(carla.override {
  stdenv = multiStdenv;
  inherit python3Packages;
}).overrideAttrs
  (old: rec {
    version = "2025-08-02"; # keep same version of ildaeil
    src = fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "12bc40fd6c9c5b36481c7df55086b27ba9ae8a80";
      hash = "sha256-CXfL67k02jMarc89mj6fggPvIJo4ZoQvUx7NqDWJkh4=";
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

    postPatch = old.postPatch + ''
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
        CFLAGS="-I${mingw32.windows.pthreads}/include -I${mcfgthreadsw32.dev}/include" \
        CXXFLAGS="-I${mingw32.windows.pthreads}/include -I${mcfgthreadsw32.dev}/include" \
        LDFLAGS="-L${mingw32.windows.pthreads}/lib -L${mcfgthreadsw32}/lib"

      make wine32 \
        CC="winegcc -m32" \
        CXX="winegcc -m32" \
        CFLAGS="-I${glibc.dev}/include" \
        CXXFLAGS="-I${glibc.dev}/include" \

      make win64 \
        CC=x86_64-w64-mingw32-gcc \
        CXX=x86_64-w64-mingw32-g++ \
        CFLAGS="-I${mingwW64.windows.pthreads}/include -I${mcfgthreadsW64.dev}/include" \
        CXXFLAGS="-I${mingwW64.windows.pthreads}/include -I${mcfgthreadsW64.dev}/include" \
        LDFLAGS="-L${mingwW64.windows.pthreads}/lib -L${mcfgthreadsW64}/lib"

      make wine64 \
        CC="winegcc" \
        CXX="winegcc" \
        CFLAGS="-I${glibc.dev}/include" \
        CXXFLAGS="-I${glibc.dev}/include"
    '';

    preFixup = ''
      rm $out/share/carla/resources/ui_carla_about.py
    '';
  })
