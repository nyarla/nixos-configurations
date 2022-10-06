{ stdenv, fetchFromGitHub, pkgsCross }:
stdenv.mkDerivation rec {
  pname = "wine-vst-wrapper";
  version = "git";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "WineVSTWrapper";
    rev = "6f4c3017dfe2a3fb50240b1ce3b3226739106a8b";
    sha256 = "1w00wq5641kr6224gdll38rpqkngf0ir42vd7a2cpnk655wiwwq3";
  };

  nativeBuildInputs = [ pkgsCross.mingwW64.buildPackages.gcc ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/share/wine-vst-wrapper/
    cp vst.dll $out/share/wine-vst-wrapper/vst.dll
  '';
}
