{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hackgen";
  version = "v2.8.0";
  src = fetchzip {
    url =
      "https://github.com/yuru7/HackGen/releases/download/${version}/HackGen_NF_${version}.zip";
    sha256 = "1srlm3z7k9qbz5rhanavrb4gr2153p65g6rn4czhkph0ibj2mca4";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r ${src}/*.ttf $out/share/fonts
  '';
}
