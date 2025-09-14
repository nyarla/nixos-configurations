{
  runCommand,
  lib,
  writeShellScript,
  coreutils,
  curl,
  grim,
  jq,
  slurp,
  xdg-utils,
}:
let
  gyazoScript = writeShellScript "gyazo.sh" ''
    set -euo pipefail

    export PATH=${
      lib.makeBinPath [
        coreutils
        curl
        grim
        slurp
        jq
        xdg-utils
      ]
    }:$PATH

    source ~/.config/gyazo/env

    fn() {
      echo /backup/Pictures/Screenshots/$(date +%Y-%m-%dT%H-%M-%S).png
    }

    upload() {
      local file=$1
      xdg-open $(curl -s \
        -F access_token=''${ACCESS_TOKEN} \
        -F imagedata=@$file \
        -F created_at=$(date +%s) \
        -F collection_id=''${COLLECTION_ID} \
        https://upload.gyazo.com/api/upload \
        | jq -r .permalink_url)
    }

    capture() {
      local filename=$(fn)
      slurp | grim -g - -t png $filename
      upload $filename
    }

    screenshot() {
      local filename=$(fn)
      grim -t png $filename
      upload $filename
    }

    main() {
      case "''${1:-}" in
        capture)
            capture
          ;;
        screenshot)
          screenshot
          ;;
      esac
    }

    main $@
  '';
in
runCommand "gyazo.sh" { } ''
  mkdir -p $out/bin/
  cp ${gyazoScript} $out/bin/gyazo
  chmod +x $out/bin/gyazo
''
