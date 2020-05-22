{ fetchFromGitHub
, pkgs
, pkgsi686Linux
, pkgsCross
, pkgconfig
, wineWowPackages
, which
}:
let
  mkCarlaDerivation = arch: pkgs:
    let
      winCross = (if arch == "32" then pkgsCross.mingw32 else pkgsCross.mingwW64);
      winPrefix = (if arch == "32" then "i686" else "x86_64");
      pthread = winCross.windows.mingw_w64_pthreads.overrideAttrs (old: {
        configureFlags = [
          "--disable-shared"
          "--enable-static"
        ];
        LDFLAGS = "-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic";
      });
    in
    pkgs.stdenv.mkDerivation rec {
      name = "carla";
      version = "v2.1";
      src = fetchFromGitHub {
        owner = "falkTX";
        repo = "carla";
        rev = "v2.1";
        sha256 = "0xfd5kcdj117djpa7j5b366lywzbmn4x2ayqfrnzm4jp4c7n0mcm";
        fetchSubmodules = true;
      };

      nativeBuildInputs = [
        pkgs.python3Packages.wrapPython
        pkgconfig
        which
        pkgs.qt5.wrapQtAppsHook
        winCross.stdenv.cc
        wineWowPackages.staging
      ];

      pythonPath = with pkgs.python3Packages; [
        rdflib
        pyliblo
        pyqt5
      ];

      buildInputs = with pkgs; [
        file
        liblo
        alsaLib
        fluidsynth
        ffmpeg
        jack2
        libpulseaudio
        libsndfile
      ] ++ pythonPath;

      installFlags = [ "PREFIX=$(out)" ];

      dontWrapQtApps = true;

      preBuild = ''
        make win${arch} \
          CC="${winPrefix}-w64-mingw32-gcc"   \
          CXX="${winPrefix}-w64-mingw32-g++"  \
          AR="${winPrefix}-w64-mingw32-ar"    \
          CFLAGS="-I${pthread}/include"     \
          CXXFLAGS="-I${pthread}/include"   \
          LDFLAGS="-L${pthread}/lib -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic"

        make wine${arch}
      '';

      postInstall = ''
        for d in carla vst/carla.vst lv2/carla.lv2 ; do
          ln -sf ${winCross.windows.mcfgthreads}/bin/mcfgthread-12.dll $out/lib/$d/mcfgthread-12.dll
        done
      '';

      postFixup = ''
        wrapPythonPrograms
        wrapPythonProgramsIn "$out/share/carla" "$pythonPath"

        find "$out/share/carla" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
          patchPythonScript "$f"
        done

        patchPythonScript "$out/share/carla/carla_settings.py"

        for program in $out/bin/*; do
          wrapQtApp "$program" \
            --prefix PATH : "$program_PATH:${which}/bin" \
            --set PYTHONNOUSERSITE true
        done
      '';
    };

  carla-32bit = mkCarlaDerivation "32" pkgsi686Linux;
  carla-64bit = mkCarlaDerivation "64" pkgs;
in
carla-64bit.overrideAttrs (old: {
  postPatch = ''
    sed -i 's|"carla-bridge-posix32"|"carla-bridge-native"|' source/backend/engine/CarlaEngine.cpp
    sed -i 's!bridgeBinary(pData->options.binaryDir);!bridgeBinary( (btype == BINARY_POSIX32 || btype == BINARY_WIN32 ) ? "${carla-32bit}/lib/carla" : pData->options.binaryDir);!' \
      source/backend/engine/CarlaEngine.cpp

    sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-posix32"|"${carla-32bit}/lib/carla/carla-discovery-native"|' \
      source/frontend/carla_database.cpp
    sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-win32.exe"|"${carla-32bit}/lib/carla/carla-discovery-win32.exe"|' \
      source/frontend/carla_database.cpp

    sed -i 's|self.host.pathBinaries, "carla-discovery-posix32"|"${carla-32bit}/lib/carla", "carla-discovery-native"|' source/frontend/carla_database.py 
    sed -i 's|self.host.pathBinaries, "carla-discovery-win32.exe"|"${carla-32bit}/lib/carla", "carla-discovery-win32.exe"|' source/frontend/carla_database.py 

    sed -i 's|self.fPathBinaries, "carla-discovery-posix32"|"${carla-32bit}/lib/carla", "carla-discovery-native"|g' source/frontend/carla_database.py
    sed -i 's|self.fPathBinaries, "carla-discovery-win32.exe"|"${carla-32bit}/lib/carla", "carla-discovery-win32.exe"|g' source/frontend/carla_database.py

    sed -i 's|os.path.join(CARLA_LIBDIR, "carla-bridge-" + ARCH)|os.path.join("${carla-32bit}/lib/carla", ("carla-bridge-native" if ARCH == "posix32" else "carla-bridge-win32")) if ARCH in ("posix32" "win32") else os.path.join(CARLA_LIBDIR, "carla-bridge-" + ARCH)|' \
      data/carla-single
  '';
})
