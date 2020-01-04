{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dropbox
    whipper
  ];

  services.dbus.packages = with pkgs; [
    whipper
  ];
}
