{ config, pkgs, ... }:
let
  apps = with pkgs; [
    networkmanagerapplet
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
  networking.networkmanager.enable = true;
}
