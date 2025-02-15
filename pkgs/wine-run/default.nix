{
  lib,
  runCommand,
  writeShellScript,
  pname ? "wine",
  paths ? "",
}:
let
  env = lib.optionalString (paths != "") ''
    export PATH=${paths}:$PATH
  '';

  wine-runtime = writeShellScript "${pname}" ''
    ${env}
    unset LD_PRELOAD

    if [[ ! -d $(pwd)/drive_c ]]; then
      echo 'This directory is not wine prefix' >&2
      exit 1
    fi

    export WINEPREFIX=$(pwd)
    exec "''${@:-}"
  '';

  wine-setup = writeShellScript "${pname}-setup" ''
    ${wine-run} wineboot -u
    ${wine-run} winetricks corefonts fakejapanese
    ${wine-run} wineboot -s
  '';

  wine-run = writeShellScript "${pname}-wine" ''
    ${env}

    case "''${0:-}" in
      *64)
        exec wine64 "''${@:-}"
        ;;
      *)
        exec wine "''${@:-}"
        ;;
    esac
  '';
in
runCommand "wine-run" { } ''
  mkdir -p $out/bin
  cp ${wine-runtime} $out/bin/${pname}
  cp ${wine-setup} $out/bin/${pname}-setup
  cp ${wine-run} $out/bin/${pname}-wine
  cp ${wine-run} $out/bin/${pname}-wine64

  chmod +x $out/bin/*
''
