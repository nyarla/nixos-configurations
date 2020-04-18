{ config, pkgs, ... }:
let
  apps = with pkgs; [
    pavucontrol lxappearance-gtk3 arandr 
    calibre deadbeef picard
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
