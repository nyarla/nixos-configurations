{ config, pkgs, ... }:
let 
  apps = with pkgs; [
    mate.mate-calc
    gucharmap
    gimp inkscape
    peek spice-up
    keepassxc
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
