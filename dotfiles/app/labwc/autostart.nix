{ fetchurl, writeShellScript, pkgs }:
let
  wallpaper = fetchurl {
    url =
      "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
in writeShellScript "autostart" ''
  eval "$(dbus-launch --sh-syntax --exit-with-session)"

  systemctl --user import-environment WAYLAND_DISPLAY

  systemctl --user start desktop-session.target
  systemctl --user start swaylock

  eval "$(/run/wrappers/bin/gnome-keyring-daemon --components=pkcs11,secrets,ssh --replace --daemonize)"
  export SSH_AUTH_SOCK
  export GNOME_KEYRING_CONTROL

  fcitx5 -rd
  ${pkgs.waybar}/bin/waybar &
  ${pkgs.xembed-sni-proxy}/bin/xembedsniproxy &
  ${pkgs.calibre}/bin/calibre --start-in-tray &
  swaybg -i ${wallpaper} -m fit &
''
