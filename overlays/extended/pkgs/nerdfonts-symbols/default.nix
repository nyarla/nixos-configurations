{ stdenv, fetchurl }:
stdenv.mkDerivation rec{
  version = "git";
  name = "nerdfont-symbols-${version}";
  src = fetchurl {
    name = "nerdfont-symbols.ttf";
    url = "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf";
    sha256 = "078ynwfl92p8pq1n3ic07248whdjm30gcvkq3sy9gas1vlpyg6an";
  };

  unpackPhase = ''
    mkdir -p nerdfont
    cp ${src} nerdfont/
  '';

  installPhase = ''
    mkdir -p    $out/share/fonts
    mv nerdfont $out/share/fonts
  '';
}
