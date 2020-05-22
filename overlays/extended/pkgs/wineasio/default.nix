{ stdenv
, fetchFromGitHub
, gnused
, ed
, libjack2
, pkgconfig
, wineWowPackages
, qt5
, python3
, pkgs
, pkgsi686Linux
}:
let
  mkWineASIODerivation = arch: pkgs: pkgs.stdenv.mkDerivation rec {
    name = "wineasio-${version}";
    version = "git";
    src = fetchFromGitHub {
      owner = "falkTX";
      repo = "wineasio";
      rev = "06901a76151dda43dd724e454940695c760c2df4";
      sha256 = "1r7bvkll10rcb4rlqx84g19ynalkwp32xn9h0nh48pbryf9viz1x";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      gnused
      pkgconfig
    ];

    buildInputs = [
      wineWowPackages.staging
      pkgs.libjack2
    ];

    postPatch = ''
      sed -i "s|= /usr|= $out|" Makefile.mk
      sed -i 's|-I$(PREFIX)/include/wine|-I${wineWowPackages.staging}/include/wine|g' Makefile.mk
      sed -i "s|= /usr|= $out|" gui/Makefile
    '';

    buildPhase = ''
      mkdir -p $out/lib/wine

      make clean
      make ${arch}
    '';

    libPrefix = if arch == "32" then "lib/wine" else "lib64/wine";

    installPhase = ''
      mkdir -p $out/${libPrefix}
      cp build${arch}/wineasio.dll.so $out/${libPrefix}/wineasio.dll.so
    '';

    dontFixup = true;
  };

  WINEASIO_32bit = mkWineASIODerivation "32" pkgsi686Linux;
  WINEASIO_64bit = mkWineASIODerivation "64" pkgs;
in
stdenv.mkDerivation rec {
  name = "wineasio-${version}";
  version = "git";
  src = fetchFromGitHub {
    owner = "falkTX";
    repo = "wineasio";
    rev = "60e6b475bdbed7c0670e2ffc9ba74145eeba771c";
    sha256 = "1hxwli0p8msilla3rvwilf0qrmnqq8dr1p4dirz2l8mjh80pywfg";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    WINEASIO_32bit
    WINEASIO_64bit
    python3
    python3.pkgs.pyqt5
    qt5.full
  ];

  pythonPath = with python3.pkgs; [
    pyqt5
  ];

  postPatch = ''
    sed -i "s|= /usr|= $out|" Makefile.mk
    sed -i 's|-I$(PREFIX)/include/wine|-I${wineWowPackages.staging}/include/wine|g' Makefile.mk
    sed -i "s|= /usr|= $out|" gui/Makefile
  '';

  buildPhase = ''
    mkdir -p $out/lib/wine
    ln -sf ${WINEASIO_32bit}/lib/wine/wineasio.dll.so $out/lib/wine/wineasio.dll.so

    mkdir -p $out/lib64/wine
    ln -sf ${WINEASIO_64bit}/lib64/wine/wineasio.dll.so $out/lib64/wine/wineasio.dll.so

    cd gui
    make
    cd ../

    cat <<EOF >gui/wineasio-settings
    #!${stdenv.shell}
    exec $out/share/wineasio/settings.py "\''$@"
    EOf
  '';

  installPhase = ''
    mkdir -p $out/bin
    cd gui
    make install
    cd ../
  '';

  fixupPhase = ''
    chmod +x $out/share/wineasio/settings.py
    wrapPythonProgramsIn "$out/share/wineasio" "$out $pythonPath"
    wrapQtApp $out/bin/wineasio-settings
  '';
}
