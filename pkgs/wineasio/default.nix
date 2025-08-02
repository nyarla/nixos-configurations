{
  multiStdenv,
  fetchFromGitHub,
  libjack2,
  pkg-config,
  wine,
  pkgsi686Linux,
  qt5,
  python3,
}:

multiStdenv.mkDerivation rec {
  pname = "wineasio";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "b5e668103ad13e6f51f4118ed7090592213e5ca2";
    hash = "sha256-Yw07XBzllbZ7l1XZcCvEaxZieaHLVxM5cmBM+HAjtQ4=";
  };

  nativeBuildInputs = [
    pkg-config
    wine
    qt5.wrapQtAppsHook
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    pkgsi686Linux.libjack2
    libjack2
    python3.pkgs.pyqt5
    qt5.qtbase
  ];

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
    install -D build32/wineasio32.dll     $out/lib/wine/i386-windows/wineasio32.dll
    install -D build32/wineasio32.dll.so  $out/lib/wine/i386-unix/wineasio32.dll.so
    install -D build64/wineasio64.dll     $out/lib/wine/x86_64-windows/wineasio64.dll
    install -D build64/wineasio64.dll.so  $out/lib/wine/x86_64-unix/wineasio64.dll.so

    cd gui
    mkdir -p $out/share/wineasio
    install -m 644 -D *.py $out/share/wineasio/
    cd ..

    install -D wineasio-settings -m 755 $out/bin/wineasio-settings

    cat <<EOF >$out/bin/wineasio-register
    if [[ ! -e drive_c ]]; then
      echo 'This directory is not wine prefix!' >&2; exit 1
    fi

    case "''${1:-}" in
      32)
        [[ ! -e drive_c/windows/system32/wineasio32.dll ]] || chmod +w drive_c/windows/system32/wineasio32.dll
        cp $out/lib/wine/i386-unix/wineasio32.dll.so \
          drive_c/windows/system32/wineasio32.dll
        wine regsvr32 wineasio32.dll
        ;;

      64)
        [[ ! -e drive_c/windows/system32/wineasio64.dll ]] || chmod +w drive_c/windows/system32/wineasio64.dll

        cp $out/lib/wine/x86_64-unix/wineasio64.dll.so \
          drive_c/windows/system32/wineasio64.dll

        wine64 regsvr32 wineasio64.dll
        ;;

      wow)
        [[ ! -e drive_c/windows/system32/wineasio32.dll ]] || chmod +w drive_c/winsows/syswow64/wineasio32.dll
        cp $out/lib/wine/i386-unix/wineasio32.dll.so \
          drive_c/windows/syswow64/wineasio32.dll
        wine regsvr32 wineasio32.dll
        ;;

      *)
        echo "Usage: wineasio-register [32|64|wow]";
        exit 0;
        ;;
    esac
    EOF

    chmod +x $out/bin/wineasio-register

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
