{ config, pkgs, ... }:
let apps = with pkgs; [ mlterm ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
