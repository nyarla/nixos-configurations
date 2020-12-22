{ config, pkgs, ... }:
let
  apps = with pkgs; [
    mlterm
    xclip
    xdg_utils
    libnotify
    run-scaled
    xmagnify
    gnome3.zenity
    gnome3.gsound
    gksu
    gnome3.dconf
    gnome3.dconf-editor
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
