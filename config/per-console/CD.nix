{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whipper

  ];

  services.dbus.packages = with pkgs; [
    whipper
  ];
}
