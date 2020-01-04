{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ntfs3g hfsprogs exfat exfat-utils btrfs-progs
    gptfdisk
    gocryptfs
  ];
  
  programs.fuse.userAllowOther = true;
}
