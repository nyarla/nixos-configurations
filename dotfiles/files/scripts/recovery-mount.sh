#!/usr/bin/env bash

set -xeuo pipefail

mkdest() {
  local dir=$1

  test -d /mnt/$dir || sudo mkdir -p /mnt/$dir
}

mount-subvol() {
  local dir=$1

  if test "x$(mount | grep "/mnt/$dir")" = "x"; then
    sudo mount -t btrfs -o compress=zstd,ssd,space_cache=v2,subvol=/$dir /dev/mapper/nixos /mnt/$dir
  fi
}

mount-bind() {
  local dest=$1

  if test "x$(mount | grep "/mnt/$dest")" = "x" ; then
    test ! -f /mnt/persist/$dest || sudo touch /mnt/$dest
    sudo mount -o bind /mnt/persist/$dest /mnt/$dest
  fi
}

# bootstrap rootfs
if test "x$(mount | grep 'none on /mnt type tmpfs')" = "x" ; then
  sudo mount -t tmpfs none /mnt
fi

# EFI
mkdest boot

# NIX
mkdest nix

# Persist
mkdest persist/etc
mkdest persist/var/log
mkdest persist/var/lib
mkdest persist/var/db
mkdest persist/home/nyarla

# /etc
mkdest etc/nixos
mkdest etc/ssh

# /var
mkdest var/lib
mkdest var/log
mkdest var/db

mkdest home/nyarla

# mount EFI
if test "x$(lsblk | grep '/mnt/boot')" = "x" ; then
  sudo mount /dev/nvme0n1p1 /mnt/boot
fi

# mount btrfs
mount-subvol nix

mount-subvol persist/etc

mount-subvol persist/var/log
mount-subvol persist/var/lib
mount-subvol persist/var/db

mount-subvol persist/home/nyarla

# bind mount
mount-bind etc/machine-id

mount-bind etc/nixos
mount-bind etc/ssh

mount-bind var/log
mount-bind var/lib
mount-bind var/db

mount-bind home/nyarla

exit 0
