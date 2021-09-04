{ config, pkgs, ... }:
let apps = with pkgs; [ whipper ];
in {
  environment.systemPackages = with pkgs; apps;
  services.dbus.packages = with pkgs; apps;
}
