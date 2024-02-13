{ multiStdenv, lib, fetchFromGitHub, libjack2, pkg-config, wine, pkgsi686Linux
, qt5, python3 }:

multiStdenv.mkDerivation rec {
  pname = "wineasio";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "56c3e9da95b467f1f64ba069864c35762251a734";
    hash = "sha256-HEnJj9yfXe+NQuPATMpPvseFs+3TkiMLd1L+fIfQd+o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs =
    [ pkg-config wine qt5.wrapQtAppsHook python3.pkgs.wrapPython ];
  buildInputs =
    [ pkgsi686Linux.libjack2 libjack2 python3.pkgs.pyqt5 qt5.qtbase ];
  pythonPath = with python3.pkgs; [ pyqt5 ];

  dontConfigure = true;
  makeFlags = [ "PREFIX=${wine}" ];

  buildPhase = ''
    runHook preBuild

    make ''${makeFlags[@]} 32
    make ''${makeFlags[@]} 64

    cd gui
    make regen
    cd ..

    cat <<EOF >wineasio-settings
    #!${multiStdenv.shell}
    exec $out/share/wineasio/settings.py "$@"
    EOF

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D build32/wineasio.dll     $out/lib/wine/i386-windows/wineasio.dll
    install -D build32/wineasio.dll.so  $out/lib/wine/i386-unix/wineasio.dll.so
    install -D build64/wineasio.dll     $out/lib/wine/x86_64-windows/wineasio.dll
    install -D build64/wineasio.dll.so  $out/lib/wine/x86_64-unix/wineasio.dll.so

    cd gui
    mkdir -p $out/share/wineasio
    install -m 644 -D *.py $out/share/wineasio/
    cd ..

    install -D wineasio-settings -m 755 $out/bin/wineasio-settings

    runHook postInstall
  '';

  fixupPhase = ''
    sed -i "s#/usr/bin/python3#${python3}/bin/python3#" $out/bin/wineasio-settings
    sed -i "s#X-PREFIX-X#$out#" $out/bin/wineasio-settings

    chmod +x $out/share/wineasio/settings.py
    wrapProgram $out/share/wineasio/settings.py \
      ''${qtWrapperArgs[@]} \
      --prefix PYTHONPATH : $PYTHONPATH 
  '';

  dontStrip = true;
}
