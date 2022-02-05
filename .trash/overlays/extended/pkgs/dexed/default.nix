{ gcc7Stdenv, fetchFromGitHub, pkgconfig, freeglut, alsaLib, curl, openssl
, freetype, libjack2, xorg, mesa }:
gcc7Stdenv.mkDerivation rec {
  name = "dexed";
  version = "0.9.4";
  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    rev = "v0.9.6";
    fetchSubmodules = true;
    sha256 = "1n0840jq1lls9czvr2fdy1h59yhrlfywziiam7b49i4y49rjmil8";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ freeglut alsaLib curl openssl freetype libjack2 mesa ]
    ++ (with xorg; [
      libX11
      libXcomposite
      libXcursor
      libXinerama
      libXrandr
      libXext
    ]);

  buildPhase = ''
    ${JUCE}/bin/Projucer --resave Dexed.jucer

    cd Builds/Linux
    make \
      CONFIG=Release \
      CXXFLAGS="-DJUCE_JACK=1 -DJUCE_ALSA -DbuildVST=1 -DbuildStandalone=1"
    cd ../../
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/vst/dexed
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp Builds/Linux/build/Dexed.so $out/lib/vst/dexed/
    cp Builds/Linux/build/Dexed $out/bin/dexed

    cp Resources/ui/dexedIcon.png $out/share/icons/hicolor/512x512/apps/
  '';
}
