{ fetchurl, writeShellScript, pkgs }:
let
  automount = uuid: path: ''
    if test -e "/dev/disk/by-uuid/${uuid}" ; then
      if test ! -d ${path} ; then
        gio mount -d ${uuid} ${path} &
      fi
    fi
  '';

  wallpaper = fetchurl {
    url =
      "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-stripes-logo.png";
    sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";
  };
in writeShellScript "autostart" ''
  run() {
    if type "''${1}" >/dev/null 2>&1 ; then
      $@ &
    fi
  }

  run swaybg -i ${wallpaper} -m fit

  ${pkgs.openbox}/libexec/openbox-xdg-autostart GNOME Mate
  systemctl --user start nm-applet

  run ydotoold
  run wl-paste -t text --watch clipman store
  run sfwbar

  swayidle -w timeout 600 'wayout --off HDMI-A-1' resume 'wayout --on HDMI-A-1' &

  if test "$(hostname)" == "nixos"; then
    ${automount "05b4746c-9eed-4228-b306-922a9ef6ac4e" "/run/media/nyarla/data"}
    ${automount "470d2a2f-bdea-49a2-8e9b-242e4f3e1381" "/run/media/nyarla/src"}

    run calibre --start-in-tray
  fi
''
