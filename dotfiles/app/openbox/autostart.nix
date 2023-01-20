{ fetchurl, writeShellScript, pkgs, isMe, ... }:
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
  for rc in $(ls /etc/profile.d); do
    . /etc/profile.d/$rc
  done

  for rc in $(ls $HOME/.config/profile.d); do
    . $HOME/.config/profile.d/$rc
  done

  export PATH=/etc/nixos/dotfiles/files/scripts:$PATH

  dbus-update-activation-environment --systemd --all
  systemctl --user start gnome-keyring

  ${isMe ''
    ${automount "470d2a2f-bdea-49a2-8e9b-242e4f3e1381" "/run/media/nyarla/data"}
  ''}

  hsetroot -fill ${wallpaper} &
  ${pkgs.openbox}/libexec/openbox-xdg-autostart GNONE MATE LXQt &

  ${isMe ''
    xss-lock -- i3lock-fancy &
  ''}

  ${isMe ''
    calibre --start-in-tray &
  ''}
''
