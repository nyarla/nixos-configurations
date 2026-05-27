{
  name,
  appname ? name,
  cmd,
  settings ? null,
  extraInit ? "",

  lib,
  fence,
  writeShellScriptBin,
  writeText,
}:
let
  settingsJSON =
    if settings != null then (writeText "${name}-settings.json" (builtins.toJSON settings)) else "";
in
writeShellScriptBin name ''
  set -euo pipefail

  settingsJSON() {
    local cwd
    cwd=$PWD

    if [[ -e "${settingsJSON}" ]]; then
      echo "${settingsJSON}"
      return 0
    fi

    if [[ -e "''${cwd}/.fence/${name}.json" ]]; then
      echo "''${cwd}/.fence/${name}.json"
      return 0
    fi

    if [[ -e "$HOME/.config/fence/${name}.json" ]]; then
      echo "$HOME/.config/fence/${name}.json"
      return 0
    fi

    echo ""
    return 0
  }

  main() {
    local settings=""
    settings="$(settingsJSON)"

    local args=""
    if [[ -e "''${settings}" ]]; then
      args="--settings ''${settings}"
    fi

    exec -a ${appname} ${lib.getExe fence} $args -- ${cmd} "''${@:-}"
  }

  ${extraInit}

  main "''${@:-}"
''
