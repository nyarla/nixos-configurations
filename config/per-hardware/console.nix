{ config, pkgs, ... }: {
  console.colors = [
    "000000"
    "FF6633"
    "CCFF00"
    "FFCC33"
    "00CCFF"
    "CC99CC"
    "00CCCC"
    "F9F9F9"
    "666666"
    "FF6633"
    "CCFF00"
    "FFCC33"
    "00CCFF"
    "CC99CC"
    "00CCCC"
    "FFFFFF"
  ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
  console.earlySetup = true;
}
