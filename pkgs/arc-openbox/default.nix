{ runCommand, fetchFromGitHub }:
let
  src = fetchFromGitHub {
    owner = "dglava";
    repo = "arc-openbox";
    rev = "5ebdb7f54271b0bf0714bc3bae46b4ea90bb29c3";
    sha256 = "0jwimfcpp5rv094z727wnbsa7p5w29g8hm9p15dlmizaifz2vknc";
  };
in runCommand "arc-openbox" { } ''
  mkdir -p $out/share/themes/
  cp -R ${src}/Arc $out/share/themes
  cp -R ${src}/Arc-Dark $out/share/themes
  cp -R ${src}/Arc-Darker $out/share/themes
''
