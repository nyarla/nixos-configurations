{ runCommand, writeShellScript, gnome, coreutils, xdotool, maim }:
let
  screenshotScript = writeShellScript "screenshot.sh" ''
    set -euo pipefail

    ok() {
      ${gnome.zenity}/bin/zenity --info --text "Captured" --icon-name=camera-photo-symbolic
    }

    capture() {
      local filename=~/Pictures/$(${coreutils}/bin/date +%Y-%m-%dT%H-%M-%S).png

      local wid=$(${xdotool}/bin/xdotool selectwindow)
      if test ! -z $wid ; then
        ${maim}/bin/maim -f png -i $wid $filename
        ok
      fi
    }

    screenshot() {
      local filename=~/Pictures/$(date +%Y-%m-%dT%H-%M-%S).png
      ${maim}/bin/maim -f png $filename
      ok
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
in runCommand "screenshot.sh" { } ''
  mkdir -p $out/bin/
  cp ${screenshotScript} $out/bin/screenshot
  chmod +x $out/bin/screenshot
''
