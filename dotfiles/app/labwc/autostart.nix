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
  export PATH=/etc/nixos/dotfiles/files/scripts:$PATH

  run() {
    local waitPID
    $@ >/dev/null 2>&1 & waitPID=$!

    while wait $waidPID ; do
      $@ >/dev/null 2>&1 & waitPID=$!
    done & echo $! >>$HOME/.cache/sw-background
  }

  once() {
    $@ &
  }

  waiting() {
    while test "x$(pgrep "$1")" = "x"; do sleep 1 ; done
  }

  run fcitx5 -rD

  run bash -c 'wl-paste -p -w clipsync copy primary'
  run bash -c 'wl-paste -w clipsync copy clipboard'
  run bash -c 'while clipnotify ; do xclip -o -selection primary    | clipsync copy primary   ; done'
  run bash -c 'while clipnotify ; do xclip -o -selection clipboard  | clipsync copy clipboard ; done'

  run xembedsniproxy
  run ydotoold

  systemctl --user start swaylock

  systemctl --user start gnome-keyring-pkcs11
  systemctl --user start gnome-keyring-secrets
  systemctl --user start gnome-keyring-ssh

  systemctl --user start polkit-mate-authentication-agent-1 

  systemctl --user start nm-applet
  systemctl --user start blueman-applet

  systemctl --user start sfwbar

  once swaybg -i ${wallpaper} -m fit

  if test "$(hostname)" == "nixos"; then
    ${automount "05b4746c-9eed-4228-b306-922a9ef6ac4e" "/run/media/nyarla/data"}
    ${automount "470d2a2f-bdea-49a2-8e9b-242e4f3e1381" "/run/media/nyarla/src"}

    env QT_QPA_PLATFORM=xcb calibre --start-in-tray &
  fi
''
