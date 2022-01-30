{ config, pkgs, ... }:
let
  apps = with pkgs; [
    gimp
    gucharmap
    inkscape
    libreoffice
    mate.mate-calc
    peek
    simple-scan
    spice-up
    gnome.pomodoro
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
