{
  sources,

  stdenvNoCC,
  lib,
  skktools,
  iconv,
}:
let
  dicts = lib.strings.concatStringsSep " + " (
    lib.lists.forEach [
      "SKK-JISYO.L"
      "SKK-JISYO.M"
      "SKK-JISYO.ML"
      "SKK-JISYO.S"
      "SKK-JISYO.fullname"
      "SKK-JISYO.geo"
      "SKK-JISYO.jinmei"
      "SKK-JISYO.law"
      "SKK-JISYO.neologd"
      "SKK-JISYO.okinawa"
      "SKK-JISYO.propernoun"
      "SKK-JISYO.station"
    ] (x: sources."${x}")
  );
in
stdenvNoCC.mkDerivation rec {
  pname = "skk-dicts-xl";
  version = "2026-10-16";
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
