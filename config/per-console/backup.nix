{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    restic
    rclone
  ];
}
