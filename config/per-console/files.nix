{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whipper
    restic
    rclone
  ];

  services.dbus.packages = with pkgs; [
    whipper
  ];
}
