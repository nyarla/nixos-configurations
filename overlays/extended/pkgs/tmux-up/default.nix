{ stdenv, gnused, fetchurl }:
stdenv.mkDerivation rec {
  name = "tmux-up-${version}";
  version = "git";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/jamesottaway/tmux-up/master/tmux-up";
    sha256 = "0mm2y72qk1k80kl6cxhgzwyvlsbmbkkiyc7igwiq6pnn0fa7nl32";
  };

  unpackPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/tmux-up
  '';

  patchPhase = ''
    substituteInPlace $out/bin/tmux-up --replace "sed '" "${gnused}/bin/sed '"
  '';

  buildPhase = ''
    chmod +x $out/bin/tmux-up
  '';

  installPhase = "true";
}
