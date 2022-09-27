{ stdenv, fetchFromGitHub, pkgsCross }:
stdenv.mkDerivation rec {
  pname = "wine-vst-wrapper";
  version = "git";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "WineVSTWrapper";
    rev = "5392ebb46bd60aeffeee1d43236433e45965f817";
    sha256 = "1iq1y8gihbhz7if77ivnfhnfb9accab31anah574i21k7cl9g0w8";
  };

  nativeBuildInputs = [ pkgsCross.mingwW64.buildPackages.gcc ];

  buildPhase = ''
    make win64
  '';

  installPhase = ''
    mkdir -p $out/share/wine-vst-wrapper/
    cp vst.dll $out/share/wine-vst-wrapper/vst.dll
  '';
}
