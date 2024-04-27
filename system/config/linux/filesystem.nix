{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    e2fsprogs
    exfat
    gocryptfs
    gptfdisk
    hfsprogs
    ntfs3g
  ];

  programs.fuse.userAllowOther = true;
}
