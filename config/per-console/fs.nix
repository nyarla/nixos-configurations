{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ntfs3g hfsprogs exfat exfat-utils btrfs-progs
    gptfdisk
    gocryptfs cryptsetup
  ];
  
  programs.fuse.userAllowOther = true;
}
