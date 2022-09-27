#!/usr/bin/env bash

set -euo pipefail

out() {
  echo "${1}" >>fonts.nix
}

fetch() {
  local name=$1 url=$2
  out "{ name = \"${1}\"; url = \"${url}\"; sha256 = \"$(nix-prefetch-url "${url}")\"; }"
}

test ! -e fonts.nix || rm fonts.nix
out '['

for weight in Black Bold DemiLight Medium Regular Thin; do
  name="NotoSansCJKjp-${weight}.otf"
  url="https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/Japanese/${name}"

  fetch $name $url
done

for weight in Black Bold ExtraLight Light Medium Regular SemiBold; do
  name="NotoSerifCJKjp-${weight}.otf"
  url="https://github.com/googlefonts/noto-cjk/raw/main/Serif/OTF/Japanese/${name}"

  fetch $name $url
done

out ']'

nixfmt fonts.nix
