{
  fetchurl,
  writeShellScript,
  writeText,

  blueman,
  calibre,
  goreman,
  networkmanagerapplet,
  waybar,
  xembed-sni-proxy,
}:
let
  wallpaper = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };

  procfile = writeText "Procfile" ''
    blueman: ${blueman}/bin/blueman-applet
    calibre: env QT_IM_MODULE= GTK_IM_MODULE= ${calibre}/bin/calibre --start-in-tray
    clipboard: wl-paste -t text -w xclip -selection clipboard
    fcitx5: fcitx5 -r
    nm-applet: ${networkmanagerapplet}/bin/nm-applet --indicator
    waybar: ${waybar}/bin/waybar
    xembedsniproxy: ${xembed-sni-proxy}/bin/xembedsniproxy
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
