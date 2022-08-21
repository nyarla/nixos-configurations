#!/usr/bin/env bash

set -euo pipefail

fetch() {
  local name=$1 url=$2
  echo "{ name = \"${1}\"; url = \"${url}\"; sha256 = \"$(nix-prefetch-url "${url}" --name ${name})\"; }" >>fonts.nix
}

test ! -e fonts.nix || rm fonts.nix
echo '[' >>fonts.nix
for weight in 'Bold' 'Italic' 'Regular' ; do
  name="HackNERDFonts-${weight}.ttf";
  url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/${weight}/complete/Hack ${weight} Nerd Font Complete.ttf"

  fetch $name "$(echo $url | sed 's/ /%20/g')"
done

fetch "BoldItalic.ttf" "$(echo 'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/BoldItalic/complete/Hack Bold Italic Nerd Font Complete.ttf' | sed 's/ /%20/g')"

echo ']' >>fonts.nix

nixfmt fonts.nix
