{ carla, glibc, pkgsCross, wine, multiStdenv }:
let
  mkCarlaWithWine = { mingw, winecc, bit, arch, src }:
    (carla.override { stdenv = multiStdenv; }).overrideAttrs (old: rec {
      inherit src;

      nativeBuildInputs = old.nativeBuildInputs
        ++ [ wine mingw.buildPackages.gcc ];

      postPatch = ''
        sed -i 's|/opt/wine-devel|${wine}|g' source/jackbridge/Makefile
        sed -i 's|/opt/wine-devel|${wine}|g' source/modules/dgl/Makefile
      '';

      postBuild = ''
        make win${bit} \
          CC=${mingw.buildPackages.gcc}/bin/${arch}-w64-mingw32-gcc \
          CXX=${mingw.buildPackages.gcc}/bin/${arch}-w64-mingw32-g++ \
          CFLAGS="-I${mingw.windows.mingw_w64_pthreads}/include" \
          CXXFLAGS="-I${mingw.windows.mingw_w64_pthreads}/include" \
          LDFLAGS="-L${mingw.windows.mingw_w64_pthreads}/lib"

        make wine${bit} \
          CC="${winecc}" \
          CXX="${winecc}" \
          CFLAGS="-I${glibc.dev}/include" \
          CXXFLAGS="-I${glibc.dev}/include"
      '';

      postInstall = ''
        cp ${mingw.windows.mcfgthreads_pre_gcc_13}/bin/mcfgthread-12.dll \
          $out/lib/carla/
      '';
    });

in carla.overrideAttrs (old:
  let
    carla_win32 = mkCarlaWithWine {
      mingw = pkgsCross.mingw32;
      winecc = "winegcc -m32";
      bit = "32";
      arch = "i686";
      inherit (old) src;
    };

    carla_win64 = mkCarlaWithWine {
      mingw = pkgsCross.mingwW64;
      winecc = "winegcc";
      bit = "64";
      arch = "x86_64";
      inherit (old) src;
    };
  in rec {
    postPatch = ''
      if test -e source/frontend/carla_database.py ; then
        sed -i 's|self.fPathBinaries, "carla-discovery-win32.exe"|"${carla_win32}/lib/carla/carla-discovery-win32.exe"|g' \
          source/frontend/carla_database.py
        sed -i 's|self.host.pathBinaries, "carla-discovery-win32.exe"|"${carla_win32}/lib/carla/carla-discovery-win32.exe"|g' \
          source/frontend/carla_database.py

        sed -i 's|self.fPathBinaries, "carla-discovery-win64.exe"|"${carla_win64}/lib/carla/carla-discovery-win64.exe"|g' \
          source/frontend/carla_database.py
        sed -i 's|self.host.pathBinaries, "carla-discovery-win64.exe"|"${carla_win64}/lib/carla/carla-discovery-win64.exe"|g' \
          source/frontend/carla_database.py

        substituteAllInPlace source/frontend/carla_database.py
      fi

      if test -e source/frontend/pluginlist/pluginlistdialog.cpp ; then
        sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-win32.exe"|"${carla_win32}/lib/carla/carla-discovery-win32.exe"|g' \
          source/frontend/pluginlist/pluginlistdialog.cpp

        sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-win64.exe"|"${carla_win64}/lib/carla/carla-discovery-win64.exe"|g' \
          source/frontend/pluginlist/pluginlistdialog.cpp
      fi

      if test -e source/frontend/C++/carla_database.cpp ; then
        sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-win32.exe"|"${carla_win32}/lib/carla/carla-discovery-win32.exe"|g' \
          source/frontend/C++/carla_database.cpp

        sed -i 's|host.pathBinaries + CARLA_OS_SEP_STR "carla-discovery-win64.exe"|"${carla_win64}/lib/carla/carla-discovery-win64.exe"|g' \
          source/frontend/C++/carla_database.cpp
      fi

      if test -e source/backend/engine/CarlaEngine.cpp ; then
        sed -i 's|bridgeBinary += CARLA_OS_SEP_STR "carla-bridge-win32.exe"|bridgeBinary = "${carla_win32}/lib/carla/carla-bridge-win32.exe"|g' \
          source/backend/engine/CarlaEngine.cpp

        sed -i 's|bridgeBinary += CARLA_OS_SEP_STR "carla-bridge-win64.exe"|bridgeBinary = "${carla_win64}/lib/carla/carla-bridge-win64.exe"|g' \
          source/backend/engine/CarlaEngine.cpp
      fi
    '';

    postInstall = ''
      ln -sf ${carla_win32}/lib/carla/carla-bridge-win32.exe $out/lib/carla/carla-bridge-win32.exe
      ln -sf ${carla_win64}/lib/carla/carla-bridge-win64.exe $out/lib/carla/carla-bridge-win64.exe

      ln -sf ${carla_win32}/lib/carla/carla-discovery-win32.exe $out/lib/carla/carla-discovery-win32.exe
      ln -sf ${carla_win64}/lib/carla/carla-discovery-win64.exe $out/lib/carla/carla-discovery-win64.exe
    '';
  })
