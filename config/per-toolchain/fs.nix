{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ntfs3g
    hfsprogs
    exfat
    btrfs-progs
    gptfdisk
    gocryptfs
    cryptsetup
    e2fsprogs
  ];

  programs.fuse.userAllowOther = true;
}
