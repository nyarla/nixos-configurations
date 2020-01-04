{ config, pkgs, ... }:
let
  apps = with pkgs; [
    mlterm
    xclip xdg_utils libnotify
    gnome3.zenity gnome3.gsound
    gnome3.dconf gnome3.dconf-editor 
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}

