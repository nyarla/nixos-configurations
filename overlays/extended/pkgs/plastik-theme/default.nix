{ stdenv, requireFile }:
let
  message = ''
    Please download from:
      - https://www.gnome-look.org/s/Gnome/p/1239261/
  '';

  themes = requireFile {
    name = "plastik-themes.tar.xz";
    sha256 = "09awnz1gx64caqwwklw0l5hihkcnkhsy77q4ly4r0jy2g989m86r";
    inherit message;
  };

in
stdenv.mkDerivation rec {
  name = "plastik-themes-${version}";
  version = "2019-09-03";
  src = themes;

  installPhase = ''
    mkdir -p $out/share/themes
    mv Plastik* $out/share/themes
  '';
}
