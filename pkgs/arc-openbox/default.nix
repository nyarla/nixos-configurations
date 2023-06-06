{ runCommand, fetchFromGitHub }:
let
  src = fetchFromGitHub {
    owner = "atkij";
    repo = "arc-openbox";
    rev = "1455709b619939d249ae69be78710ca575681281";
    sha256 = "sha256-dmx8HGxUCx69ZJIffrfLsOvT8S6nwF+vLyDiNI5ojks=";
  };
in runCommand "arc-openbox" { } ''
  mkdir -p $out/share/themes/
  cp -R ${src}/Arc $out/share/themes
  cp -R ${src}/Arc-Dark $out/share/themes
  cp -R ${src}/Arc-Darker $out/share/themes
''
