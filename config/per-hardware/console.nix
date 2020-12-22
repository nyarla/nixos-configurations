{ config, pkgs, ... }: {
  console.colors = [
    "242424"
    "C75646"
    "8EB33B"
    "D0B03C"
    "72B3CC"
    "C8A0D1"
    "218693"
    "B0B0B0"
    "5D5D5D"
    "E09690"
    "CDEE69"
    "FFE377"
    "9CD9F0"
    "FBB1F9"
    "77DFD8"
    "F7F7F7"
  ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
}
