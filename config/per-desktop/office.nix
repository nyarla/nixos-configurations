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
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
