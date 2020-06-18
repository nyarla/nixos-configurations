{ config, pkgs, ... }:
let
  apps = with pkgs; [
    light
    hsetroot
    wmctrl
    maim
    xdotool
    xtitle
    xorg.xsetroot
    xorg.xwininfo
    xorg.xdpyinfo
    xorg.xrdb
  ];
in
{
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
