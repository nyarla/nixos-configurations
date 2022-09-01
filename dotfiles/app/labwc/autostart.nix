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
    if type "''${1}" >/dev/null 2>&1 ; then
      $@ &
    fi
  }

  run fcitx5 -rd

  wl-paste -p -w clipsync copy primary &
  wl-paste -w clipsync copy clipboard &
  while clipnotify ; do xclip -o -selection primary | clipsync copy primary ; done &
  while clipnotify ; do xclip -o -selection clipboard | clipsync copy clipboard ; done &

  systemctl --user start gnome-keyring-pkcs11
  systemctl --user start gnome-keyring-secrets
  systemctl --user start gnome-keyring-ssh

  systemctl --user start polkit-mate-authentication-agent-1 

  systemctl --user start sfwbar

  systemctl --user start nm-applet
  systemctl --user start blueman-applet

  run swaybg -i ${wallpaper} -m fit
  run xembedsniproxy

  run ydotoold
  swayidle -w \
    timeout 60 'swaylock -f' \
    timeout 90 'wayout --off HDMI-A-1' resume 'wayout --on HDMI-A-1' \
    before-sleep 'swaylock -f' \
    lock 'swaylock -f' \
  &

  if test "$(hostname)" == "nixos"; then
    ${automount "05b4746c-9eed-4228-b306-922a9ef6ac4e" "/run/media/nyarla/data"}
    ${automount "470d2a2f-bdea-49a2-8e9b-242e4f3e1381" "/run/media/nyarla/src"}

    run calibre --start-in-tray
  fi
''
