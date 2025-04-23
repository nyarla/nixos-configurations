{
  stdenvNoCC,
  lib,
  fetchurl,
}:
let
  fonts = import ./fonts.nix;
in
stdenvNoCC.mkDerivation rec {
  version = "V2.0003";
  name = "noto-fonts-jp-${version}";

  files = map (
    {
      name,
      url,
      sha256,
    }:
    fetchurl { inherit name url sha256; }
  ) fonts;

  unpackPhase = ''
    mkdir -p noto

    ${lib.strings.concatMapStrings (font: ''
      cp ${font} noto/${font.name} 
    '') files}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv noto $out/share/fonts/
  '';
}
