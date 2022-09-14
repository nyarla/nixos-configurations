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

  systemctl --user start mympd

  systemctl --user import-environment WAYLAND_DISPLAY DISPLAY HOME

  fcitx -rD      &
  xembedsniproxy  &
  ydotoold        &

  systemctl --user start clipsync-wayland-to-xorg-primary
  systemctl --user start clipsync-wayland-to-xorg-clipboard

  systemctl --user start swaylock

  systemctl --user start gnome-keyring-pkcs11
  systemctl --user start gnome-keyring-secrets
  systemctl --user start gnome-keyring-ssh

  systemctl --user start polkit-mate-authentication-agent-1 

  systemctl --user start nm-applet
  systemctl --user start blueman-applet

  systemctl --user start sfwbar

  swaybg -i ${wallpaper} -m fit &

  if test "$(hostname)" == "nixos"; then
    ${automount "05b4746c-9eed-4228-b306-922a9ef6ac4e" "/run/media/nyarla/data"}
    ${automount "470d2a2f-bdea-49a2-8e9b-242e4f3e1381" "/run/media/nyarla/src"}

    env QT_QPA_PLATFORM=xcb calibre --start-in-tray &
  fi
''
