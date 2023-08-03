_: {
  services.kdeconnect.indicator = true;
  systemd.user.services.kdeconnect-indicator.Unit.After =
    [ "graphical-session.target" "lxqt-panel.service" ];
}
