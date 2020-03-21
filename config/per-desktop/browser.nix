{ config, pkgs, ... }:
let 
  apps = with pkgs; [
    firefox-bin
    transmission-gtk
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
