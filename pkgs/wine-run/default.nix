{ writeShellScriptBin, runCommand }:
let
  wine-run = writeShellScriptBin "wine-run" ''
    export LD_PRELOAD=

    if ! test -e $(pwd)/drive_c ; then
      echo 'This path is not wine prefix' >&2
      exit 1
    fi

    export WINEPREFIX=$(pwd)

    exec "''${@:-}"
  '';

  wine-setup = writeShellScriptBin "wine-setup" ''
    ${wine-run} wineboot -u
    ${wine-run} winetricks corefonts fakejapanese
    ${wine-run} wineboot -s
  '';
in
runCommand "wine-run" { } ''
  mkdir -p $out/bin
  cp -r ${wine-run}/bin/* $out/bin/
  cp -r ${wine-setup}/bin/* $out/bin/

  chmod +x $out/bin/*
''
