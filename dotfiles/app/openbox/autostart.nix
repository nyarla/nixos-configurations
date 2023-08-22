{ fetchurl, writeShellScript, pkgs, ... }:
let
  # automount = uuid: path: ''
  #   if test -e "/dev/disk/by-uuid/${uuid}" ; then
  #     if test ! -d ${path} ; then
  #       gio mount -d ${uuid} ${path} &
  #     fi
  #   fi
  # '';

  wallpaper = fetchurl {
    url =
      "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };

in writeShellScript "autostart" ''
  systemctl --user unset-environment WAYLAND_DISPLAY
  systemctl --user start desktop-session.target
  systemctl --user restart picom
  systemctl --user restart xss-lock

  ${pkgs.hsetroot}/bin/hsetroot -fill ${wallpaper} &
''
