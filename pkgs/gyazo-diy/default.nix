{ runCommand, writeShellScript, curl, coreutils, jq, xdotool, maim, xdg-utils }:
let
  gyazoScript = writeShellScript "gyazo.sh" ''
    set -euo pipefail

    source ~/.config/gyazo/env

    upload() {
      local file=$1
      ${xdg-utils}/bin/xdg-open $(${curl}/bin/curl -s \
        -F access_token=''${ACCESS_TOKEN} \
        -F imagedata=@$file \
        -F created_at=$(${coreutils}/bin/date +%s) \
        -F collection_id=''${COLLECTION_ID} \
        https://upload.gyazo.com/api/upload \
        | ${jq}/bin/jq -r .permalink_url)
    }

    capture() {
      local filename=~/Pictures/$(date +%Y-%m-%dT%H-%M-%S).png

      local wid=$(${xdotool}/bin/xdotool selectwindow)
      if test ! -z $wid ; then
        ${maim}/bin/maim -f png -i $wid $filename
        upload $filename
      fi
    }

    screenshot() {
      local filename=~/Pictures/$(date +%Y-%m-%dT%H-%M-%S).png
      ${maim}/bin/maim -f png $filename
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
in runCommand "gyazo.sh" { } ''
  mkdir -p $out/bin/
  cp ${gyazoScript} $out/bin/gyazo
  chmod +x $out/bin/gyazo
''
