{ stdenv, fetchurl, lib }:
let fonts = import ./fonts.nix;
in stdenv.mkDerivation rec {
  pname = "hack-nerdfonts";
  version = "2022-08-21";
  srcs = map (font: fetchurl font) fonts;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    ${lib.strings.concatMapStrings (font: ''
      cp ${font} $out/share/fonts/${font.name}
    '') srcs}
  '';
}
