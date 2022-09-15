{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hackgen";
  version = "v2.7.1";
  src = fetchzip {
    url =
      "https://github.com/yuru7/HackGen/releases/download/${version}/HackGen_${version}.zip";
    sha256 = "09lpb1q517gy5kgdmgpz3wg9cs2in0fk6nrccwy8nksxdpnabchf";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r ${src}/*.ttf $out/share/fonts
  '';
}
