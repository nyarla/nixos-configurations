{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aria2
    bind
    curlFull
    rclone
    restic
    restic-run
    wget
  ];
}
