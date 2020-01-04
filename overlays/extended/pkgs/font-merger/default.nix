{ stdenv, python2, python2Packages, fetchFromGitHub, fetchurl, fontforge}:
let
  font-linux = fetchurl {
    url = "https://raw.githubusercontent.com/lukas-w/font-logos/master/assets/font-logos.ttf";
    sha256 = "1d8jz988s7m11y9nyp6ly4i1d398jcdkjnxpbcizcmndlc2cdh8w";
  };
in
stdenv.mkDerivation rec {
  name    = "fontmerger";
  version = "git";
  src = fetchFromGitHub {
    owner   = "iij";
    repo    = "fontmerger";
    rev     = "3432e19b6d99422889c4ceec4d9f4dbb25000cc8";
    sha256  = "0cbmks0x93gn72avpayhvr0lr77gnsb81yq2iq9rg985idgsv626";
  };

  buildInputs = [
    python2 fontforge
  ];

  patchPhase = ''
    sed -i "s!default='./fonts.json'!default='$out/share/fontmerger/fonts.json'!" fontmerger/__init__.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/fontmerger
    cp -R . $out/share/fontmerger

    cp ${font-linux} $out/share/fontmerger/fonts/font-linux/font-linux.ttf

    cat <<EOF >$out/bin/fontmerger
    #! ${stdenv.shell}
    export PATH=${python2}/bin:${fontforge}/bin:\''$PATH
    cd $out/share/fontmerger
    exec bash bin/fontmerger "\''${@:-}"
    EOF

    chmod +x $out/bin/fontmerger
  '';
}
