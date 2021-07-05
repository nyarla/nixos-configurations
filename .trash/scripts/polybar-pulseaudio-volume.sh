#!/usr/bin/env zsh

function main() {
  local IDX=${1:-1}
  local VOL="$(pactl list sinks | grep Volume | grep -v Base |  sed -n ${IDX}p | sed -e 's/.\+\([0-9]\{2\}%\).\+/\1/' )"
  notify-send -i audio-subwoofer -u low Volume $VOL
}

main "${@}"
