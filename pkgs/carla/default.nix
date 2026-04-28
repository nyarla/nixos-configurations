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
(carla.override {
  stdenv = multiStdenv;
}).overrideAttrs
  (old: {
    version = "2026-02-22"; # keep same version of ildaeil
    src = fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "294a80145e39c0755ab9073d90fd8b9524fbfc84";
      hash = "sha256-rOjFxk0KbnnPpRJUWcN5W1A2pDGIdztwK4LL5hPb+sQ=";
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

    postPatch = (old.postPatch or "") + ''
      export carla=$out
      export wine=${wine}

      substituteAllInPlace source/jackbridge/Makefile
      substituteAllInPlace source/modules/dgl/Makefile
      substituteAllInPlace source/backend/CarlaStandalone.cpp
      substituteAllInPlace source/backend/engine/CarlaEngineJack.cpp
    '';

    postBuild = ''
      make wine64 \
        CFLAGS="-I${glibc.dev}/include" \
        CXXFLAGS="-I${glibc.dev}/include" \
        LDFLAGS="-L${wine}/lib/wine/x86_64-windows"
    '';

    preFixup = ''
      rm $out/share/carla/resources/ui_carla_about.py
    '';
  })
