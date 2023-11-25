{ lib, config, pkgs, ... }: {
  services.kdeconnect.indicator = true;
  systemd.user.services.kdeconnect-indicator.Service.Environment = lib.mkForce [
    "LANG=ja_JP.UTF-8"
    "LC_ALL=ja_JP.UTF-8"
    "PATH=${config.home.profileDirectory}/bin"
  ];
  systemd.user.services.kdeconnect-indicator.Unit.After =
    [ "graphical-session.target" "desktop-panel.service" ];
}
