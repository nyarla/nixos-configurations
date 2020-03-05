{ fetchFromGitHub, pkgs, pkgsi686Linux, pkgsCross, pkgconfig, wineWowPackages,
  which }:
let
  mkCarlaDerivation = arch: pkgs: let
    winCross  = (if arch == "32" then pkgsCross.mingw32 else pkgsCross.mingwW64);
    winPrefix = (if arch == "32" then "i686" else "x86_64");
    pthread = winCross.windows.mingw_w64_pthreads.overrideAttrs (old: {
      configureFlags = [
        "--disable-shared"
        "--enable-static"
      ];
      LDFLAGS = "-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic";
    });
  in pkgs.stdenv.mkDerivation rec {
    name    = "carla";
    version = "v2.1-rc1";
    src     = fetchFromGitHub {
      owner   = "falkTX";
      repo    = "carla";
      rev     = "v2.1-rc1";
      sha256  = "19bxdhdnplzwr4kny1dahzxcgm9zph38zfrzcj0hr9zxalg5gb2l";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      pkgs.python3Packages.wrapPython pkgconfig which
      pkgs.qt5.wrapQtAppsHook winCross.stdenv.cc
      wineWowPackages.staging
    ];

    pythonPath = with pkgs.python3Packages; [
      rdflib pyliblo pyqt5
    ];

    buildInputs = with pkgs; [
      file liblo alsaLib fluidsynth ffmpeg jack2 libpulseaudio libsndfile
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
in carla-64bit.overrideAttrs (old: {
  postInstall = ''
    for d in carla vst/carla.vst lv2/carla.lv2 ; do
      ln -sf ${carla-32bit}/lib/carla/carla-bridge-win32.exe $out/lib/$d/carla-bridge-win32.exe 
      ln -sf ${carla-32bit}/lib/carla/carla-discovery-win32.exe $out/lib/$d/carla-discovery-win32.exe 
      ln -sf ${carla-32bit}/lib/carla/jackbridge-wine32.dll $out/lib/$d/jackbridge-wine32.dll 
    done
  '' + old.postInstall;
}) 
