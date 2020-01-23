{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whipper
    dropbox
    restic rclone
  ];

  services.dbus.packages = with pkgs; [
    whipper
  ];
}
