{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ bup rclone restic ];
}
