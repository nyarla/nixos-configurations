#!/usr/bin/env bash

fetch() {
  local name=$1 url=$2
  npins add url --name "${name}" "${url}" 
}

main() {
  for dict in S M ML L jinmei fullname geo law okinawa propernoun station; do
    name="SKK-JISYO.${dict}"
    fetch $name "https://raw.githubusercontent.com/skk-dev/dict/master/${name}"
  done

  fetch "SKK-JISYO.neologd" "https://raw.githubusercontent.com/tokuhirom/skk-jisyo-neologd/master/SKK-JISYO.neologd"
}

main;
