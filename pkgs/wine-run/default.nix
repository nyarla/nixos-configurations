{ writeShellScript, runCommand }:
let
  wine-run = writeShellScript "wine-run" ''
    export LD_PRELOAD=

    if ! test -e $(pwd)/drive_c ; then
      echo 'This path is not wine prefix' >&2
      exit 1
    fi

    export WINEPREFIX=$(pwd)

    exec "''${@:-}"
  '';

  wine-setup = writeShellScript "wine-setup" ''
    ${wine-run} wineboot -u
    ${wine-run} winetricks corefonts fakejapanese
    ${wine-run} wineboot -s
  '';
in
runCommand "wine-run" { } ''
  mkdir -p $out/bin
  cp ${wine-run} $out/bin/wine-run
  chmod +x $out/bin/wine-run

  cp ${wine-setup} $out/bin/wine-setup
  chmod +x $out/bin/wine-setup
''
