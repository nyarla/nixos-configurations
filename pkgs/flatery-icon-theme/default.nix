{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "flatery-icon-theme";
  version = "git";
  src = fetchFromGitHub {
    owner = "cbrnix";
    repo = "Flatery";
    rev = "30bef81ba98ac4c4f764e9fc1b705a86e0d27e2c";
    sha256 = "0vv507v0ijjdpbfy57b9skyp4qql5f5pdd9ja0bcbc0l2gmp7pma";
  };

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/share/icons/

    mv Flatery $out/share/icons/
    mv Flatery-Black $out/share/icons/
    mv Flatery-Black-Dark $out/share/icons/
    mv Flatery-Blue $out/share/icons/
    mv Flatery-Blue-Dark $out/share/icons/
    mv Flatery-Dark $out/share/icons/
    mv Flatery-Gray $out/share/icons/
    mv Flatery-Gray-Dark $out/share/icons/
    mv Flatery-Green $out/share/icons/
    mv Flatery-Green-Dark $out/share/icons/
    mv Flatery-Indigo $out/share/icons/
    mv Flatery-Indigo-Dark $out/share/icons/
    mv Flatery-Mint $out/share/icons/
    mv Flatery-Mint-Dark $out/share/icons/
    mv Flatery-Orange $out/share/icons/
    mv Flatery-Orange-Dark $out/share/icons/
    mv Flatery-Pink $out/share/icons/
    mv Flatery-Pink-Dark $out/share/icons/
    mv Flatery-Sky $out/share/icons/
    mv Flatery-Sky-Dark $out/share/icons/
    mv Flatery-Teal $out/share/icons/
    mv Flatery-Teal-Dark $out/share/icons/
    mv Flatery-Yellow $out/share/icons/
    mv Flatery-Yellow-Dark $out/share/icons/
  '';
}
