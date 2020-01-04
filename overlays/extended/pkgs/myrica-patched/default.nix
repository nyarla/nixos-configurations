{ stdenv, fetchurl, fontmerger, myrica, fontforge }:
let
  script = fetchurl {
    url = "https://gist.githubusercontent.com/fatum12/941a10f31ac1ad48ccbc/raw/15b0b59bd4b372740ce944474ba103f6548b73f3/ttc2ttf.pe";
    sha256 = "09zd1g5hp6dhwlql7swq85xdg6idakl844qiprkyz52j4hbbd77i";
  };
in stdenv.mkDerivation rec {
  name    = "myrica-patched";
  version = "0.0.1";
  
  nativeBuildInputs = [
    fontmerger fontforge
  ];

  unpackPhase = ''
    fontforge -script ${script} ${myrica}/share/fonts/truetype/Myrica.TTC 
    fontforge -script ${script} ${myrica}/share/fonts/truetype/MyricaM.TTC 
  '';

  buildPhase = ''
    fontmerger --verbose --all --suffix=Patched --output=`pwd` -- `pwd`/MyricaM.ttf
    fontmerger --verbose --all --suffix=Patched --output=`pwd` -- `pwd`/MyricaMM.ttf
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp MyricaM*Patched*.ttf $out/share/fonts/truetype
  '';
}
