{ config, pkgs, ... }:
let
  apps = with pkgs; [
    calligra
    gimp
    gucharmap
    inkscape
    mate.mate-calc
    peek
    simple-scan
    spice-up
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
