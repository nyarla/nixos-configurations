{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hackgen";
  version = "2.9.0";
  src = fetchzip {
    url =
      "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_NF_v${version}.zip";
    sha256 = "sha256-Lh4WQJjeP4JuR8jSXpRNSrjRsNPmNXSx5AItNYMJL2A=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r ${src}/*.ttf $out/share/fonts
  '';
}
