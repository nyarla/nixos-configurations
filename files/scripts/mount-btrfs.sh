#!/usr/bin/env bash

test -d /tmp/btrfs      || sudo mkdir -p /tmp/btrfs
test -d /tmp/btrfs/nix  || sudo mount -t btrfs -o compress=zstd,ssd,space_cache=v2 /dev/mapper/nixos /tmp/btrfs
