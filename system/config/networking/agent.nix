{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aria
    bind
    curlFull
    rclone
    restic
    restic-run
    wget
  ];
}
