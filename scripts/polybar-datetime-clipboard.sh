#!/usr/bin/env sh

date +%Y-%m-%dT%H:%M:%S | clipboard set -
notify-send -i calendar -u low Datetime "Copied datetime to clipboard"
