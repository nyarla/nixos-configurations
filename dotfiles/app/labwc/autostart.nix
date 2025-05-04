{
  fetchurl,
  writeShellScript,
  writeText,

  blueman,
  calibre,
  goreman,
  lxqt,
  networkmanagerapplet,
  qpwgraph,
  xembed-sni-proxy,
}:
let
  wallpaper = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-mosaic-blue.png";
    sha256 = "1cbcssa8qi0giza0k240w5yy4yb2bhc1p1r7pw8qmziprcmwv5n5";
  };

  procfile = writeText "Procfile" ''
    blueman: ${blueman}/bin/blueman-applet
    calibre: env QT_IM_MODULE= GTK_IM_MODULE= ${calibre}/bin/calibre --start-in-tray
    clipboard: wl-paste -t text -w xclip -selection clipboard
    fcitx5: fcitx5 -r
    nm-applet: ${networkmanagerapplet}/bin/nm-applet --indicator
    lxqt-panel: ${lxqt.lxqt-panel}/bin/lxqt-panel
    xembedsniproxy: ${xembed-sni-proxy}/bin/xembedsniproxy
    qpwgraph: ${qpwgraph}/bin/qpwgraph -m
  '';
in
writeShellScript "autostart" ''
  cd $HOME
  chmod +w .Procfile
  cp ${procfile} .Procfile

  systemctl --user import-environment WAYLAND_DISPLAY

  systemctl --user start desktop-session.target
  systemctl --user start swaylock

  eval "$(/run/wrappers/bin/gnome-keyring-daemon --components=pkcs11,secrets,ssh --replace --daemonize)"
  export SSH_AUTH_SOCK
  export GNOME_KEYRING_CONTROL

  ${goreman}/bin/goreman -f .Procfile start &

  swaybg -i ${wallpaper} -m fit &
''
