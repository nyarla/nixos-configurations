{
  fetchurl,
  writeShellScript,
  pkgs,
}:
let
  wallpaper = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };

  launch = cmd: ''
    while [[ -e /run/user/$(id -u)/wayland-0 ]]; do
      env \
        XDG_DATA_DIRS=$HOME/.nix-profile/share:/run/current-system/sw/share \
        ${cmd}
    done &
  '';
in
writeShellScript "autostart" ''

  systemctl --user import-environment WAYLAND_DISPLAY

  systemctl --user start desktop-session.target
  systemctl --user start swaylock

  eval "$(/run/wrappers/bin/gnome-keyring-daemon --components=pkcs11,secrets,ssh --replace --daemonize)"
  export SSH_AUTH_SOCK
  export GNOME_KEYRING_CONTROL

  ${launch "${pkgs.waybar}/bin/waybar"}
  ${launch "${pkgs.xembed-sni-proxy}/bin/xembedsniproxy"}
  ${launch "fcitx5 -r"}
  ${launch "${pkgs.calibre}/bin/calibre --start-in-tray"}
  ${launch "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"}
  ${launch "${pkgs.blueman}/bin/blueman-applet"}
  ${launch "wl-paste -t text -w xclip -selection clipboard"}

  swaybg -i ${wallpaper} -m fit &
''
