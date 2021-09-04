{ config, pkgs, ... }:
let apps = with pkgs; [ calibre deadbeef picard ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
