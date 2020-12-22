{ config, pkgs, ... }:
let
  apps = with pkgs; [ pavucontrol lxappearance arandr calibre deadbeef picard ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
