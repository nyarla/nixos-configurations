{ config, pkgs, ... }:
let 
  apps = with pkgs; [
    firefox-bin
    transmission-gtk
    browserpass
    qtpass
    pinentry-gnome libsecret
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
