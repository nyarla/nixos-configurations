#!/run/current-system/sw/bin/bash

export PATH="/run/current-system/sw/bin"
export USER="nyarla"
export HOME="/home/$USER"
export DISPLAY=":1"

cd /etc/nixos/overlays/vmnix/etc/
make start || true

