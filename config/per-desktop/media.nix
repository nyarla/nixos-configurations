{ config, pkgs, ... }:
let
  apps = with pkgs; [
    pavucontrol lxappearance-gtk3 arandr
    calibre deadbeef
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
