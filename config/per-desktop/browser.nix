{ config, pkgs, ... }:
let 
  apps = with pkgs; [
    chromium
    uget
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
