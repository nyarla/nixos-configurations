{ config, pkgs, ... }:
let 
  apps = with pkgs; [
    wineWowPackages.staging
    (winetricks.override { wine = wineWowPackages.staging
    ; }) 
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
