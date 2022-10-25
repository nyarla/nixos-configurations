{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hackgen";
  version = "v2.7.1";
  src = fetchzip {
    url =
      "https://github.com/yuru7/HackGen/releases/download/${version}/HackGen_NF_${version}.zip";
    sha256 = "sha256-OwXbQuw1zaWKZriO9hawDc7qXTQTqomKk7frTicWFug=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r ${src}/*.ttf $out/share/fonts
  '';
}
