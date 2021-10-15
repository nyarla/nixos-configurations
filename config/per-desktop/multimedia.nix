{ config, pkgs, ... }:
let
  apps = with pkgs; [
    calibre
    quodlibet-full
    picard
    glib.out
    audacity
    deadbeef
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
