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
  version = "2024-03-02";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "652964155dcee005078c7cb652656e8a0b995186";
    hash = "sha256-2wMZ+TIuD8eECTfJ0rz5JmL4sdLGVm6GMxW9CAkvIoI=";
    fetchSubmodules = true;
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
