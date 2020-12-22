{ config, pkgs, ... }:
let
  apps = with pkgs; [
    wineWowPackages.staging
    (winetricks.override { wine = wineWowPackages.staging; })
    samba
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
