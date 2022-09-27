{ stdenv, fetchFromGitHub, gnused, pkg-config, wine, qt5, python3
, python3Packages, pkgs, pkgsi686Linux }:
let
  source = fetchFromGitHub {
    owner = "wineasio";
    repo = "wineasio";
    rev = "56c3e9da95b467f1f64ba069864c35762251a734";
    sha256 = "1skps23przjjfw5j74nkxnrqbixy9z54rh738a6yypczvj7wjj8w";
    fetchSubmodules = true;
  };

  mkWineAsioDerivation = arch: pkgs:
    pkgs.stdenv.mkDerivation rec {
      pname = "wineasio-${arch}";
      version = "git";
      src = source;
      nativeBuildInputs = [ gnused pkg-config ];

      buildInputs = [ wine pkgs.libjack2 ];

      postPatch = ''
        sed -i "s!= /usr!= $out!" Makefile.mk
        sed -i 's!-I$(PREFIX)/!-I${wine}/!g' Makefile.mk
      '';

      buildPhase = ''
        make clean
        make ${arch}
      '';

      libPrefix = if arch == "32" then "lib/wine/i386" else "lib/wine/x86_64";

      installPhase = ''
        mkdir -p $out/${libPrefix}-windows/
        mkdir -p $out/${libPrefix}-unix/

        cp build${arch}/wineasio.dll $out/${libPrefix}-windows/
        cp build${arch}/wineasio.dll.so $out/${libPrefix}-unix/
      '';

      dontFixup = true;
    };

  wineasio_32bit = mkWineAsioDerivation "32" pkgsi686Linux;
  wineasio_64bit = mkWineAsioDerivation "64" pkgs;
in stdenv.mkDerivation rec {
  pname = "wineasio";
  version = "git";
  src = source;

  nativeBuildInputs = [ qt5.wrapQtAppsHook python3.pkgs.wrapPython ];

  buildInputs =
    [ wineasio_32bit wineasio_64bit python3 python3Packages.pyqt5 qt5.full ];

  pythonPath = with python3Packages; [ pyqt5 ];

  postPatch = ''
    sed -i "s!= /usr!= $out!" gui/Makefile
  '';

  buildPhase = ''
    cd gui
    make
    cd ..

    cat <<EOF >gui/wineasio-settings
    #!${stdenv.shell}
    exec $out/share/wineasio/settings.py $@
    EOF
  '';

  installPhase = ''
    for bit in i386 x86_64 ; do
      mkdir -p $out/lib/wine/''${bit}-unix/
      mkdir -p $out/lib/wine/''${bit}-windows/
    done

    cp ${wineasio_32bit}/lib/wine/i386-windows/wineasio.dll $out/lib/wine/i386-windows/
    cp ${wineasio_32bit}/lib/wine/i386-unix/wineasio.dll.so $out/lib/wine/i386-unix/
    cp ${wineasio_64bit}/lib/wine/x86_64-windows/wineasio.dll $out/lib/wine/x86_64-windows/
    cp ${wineasio_64bit}/lib/wine/x86_64-unix/wineasio.dll.so $out/lib/wine/x86_64-unix/

    mkdir -p $out/bin
    cd gui
    make install
    cd ..
  '';

  fixupPhase = ''
    chmod +x $out/share/wineasio/settings.py
    sed -i 's|#!/usr/bin/env python3|#!${python3}/bin/python3|' $out/share/wineasio/settings.py
    wrapProgram $out/share/wineasio/settings.py \
      ''${qtWrapperArgs[@]} \
      --prefix PYTHONPATH : $PYTHONPATH 
  '';

  dontStrip = true;
}
