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
      "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
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

    kdeconnect-indicator &

    calibre --start-in-tray &
    1password --silent &
  ''}
''
