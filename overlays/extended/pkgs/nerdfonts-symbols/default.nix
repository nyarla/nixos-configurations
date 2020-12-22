{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  version = "git";
  name = "nerdfont-symbols-${version}";
  src = fetchurl {
    name = "nerdfont-symbols.ttf";
    url =
      "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf";
    sha256 = "004nlkn834p544rx9jm1zf6ag3zyk3y318ispk4yih07fy7yasyz";
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
