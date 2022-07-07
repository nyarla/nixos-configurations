{ stdenv, ncurses }:
stdenv.mkDerivation rec {
  pname = "terminfo-mlterm-256color";
  version = "2021-11-11";
  dontUnpack = true;

  nativeBuildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/share/terminfo
    tic -o$out/share/terminfo -x ${./terminfo}
  '';
}
