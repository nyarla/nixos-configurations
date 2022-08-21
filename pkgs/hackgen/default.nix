{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hackgen";
  version = "v2.7.0";
  src = fetchzip {
    url =
      "https://github.com/yuru7/HackGen/releases/download/${version}/HackGen_${version}.zip";
    sha256 = "1phimpm5sb6lany94w4gbhi2fmn0agdhh31k329hdkl8bvl2lfln";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r ${src}/*.ttf $out/share/fonts
  '';
}
