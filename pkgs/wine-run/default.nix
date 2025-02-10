{
  lib,
  runCommand,
  writeShellScript,
  pname ? "wine",
  wine ? null,
}:
let
  env = lib.optionalString (wine != null) ''
    export PATH=${wine}/bin:$PATH
  '';

  wine-run = writeShellScript "${pname}" ''
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
in
runCommand "wine-run" { } ''
  mkdir -p $out/bin
  cp ${wine-run} $out/bin/${pname}
  cp ${wine-setup} $out/bin/${pname}-setup

  chmod +x $out/bin/*
''
