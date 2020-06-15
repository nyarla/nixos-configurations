{ config, pkgs, ... }:
let
  apps = with pkgs; [
    firefox-bin
    thunderbird-bin
    transmission-gtk
    pinentry-gnome
    libsecret
  ];
in
{
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
