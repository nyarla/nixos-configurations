{
  stdenvNoCC,
  lib,
  fetchurl,
  skktools,
  iconv,
}:
let
  dicts = lib.strings.concatStringsSep " + " (
    lib.lists.forEach (import ./skk.nix) (x: fetchurl { inherit (x) name url sha256; })
  );
in
stdenvNoCC.mkDerivation rec {
  pname = "skk-dicts-xl";
  version = "2022-07-07";
  dontUnpack = true;

  nativeBuildInputs = [
    skktools
    iconv
  ];

  installPhase = ''
    set -x
    mkdir -p $out/share/skk/

    echo ';; -*- mode: fundamental; coding: euc-jp -*-' >$out/share/skk/SKK-JISYO.XL
    skkdic-expr2 ${dicts} >>$out/share/skk/SKK-JISYO.XL

    echo ';; -*- mode: fundamental; coding: utf8 -*-' >$out/share/skk/SKK-JISYO.XL.utf8
    iconv -c -f EUC-JP -t UTF8 < $out/share/skk/SKK-JISYO.XL >>$out/share/skk/SKK-JISYO.XL.utf8 || true
  '';
}
