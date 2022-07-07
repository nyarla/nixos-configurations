#!/usr/bin/env bash

out() {
  echo "${1}" >>skk.nix
}

fetch() {
  local name=$1 url=$2
  out "{ name = \"${1}\"; url = \"${url}\"; sha256 = \"$(nix-prefetch-url "${url}")\"; }"
}

main() {
  test ! -e skk.nix || rm skk.nix

  out '['
  for dict in S M ML L fullname geo law okinawa propernoun station; do
    name="SKK-JISYO.${dict}"
    fetch $name "https://raw.githubusercontent.com/skk-dev/dict/master/${name}"
  done

  fetch "SKK-JISYO.neologd" "https://raw.githubusercontent.com/tokuhirom/skk-jisyo-neologd/master/SKK-JISYO.neologd"
  
  out ']'

  nixfmt skk.nix
}

main;
