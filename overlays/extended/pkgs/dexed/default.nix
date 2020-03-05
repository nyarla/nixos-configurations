{ gcc7Stdenv, fetchurl, pkgconfig,
  freeglut, alsaLib, curl, openssl, freetype, libjack2, xorg, mesa
}:
gcc7Stdenv.mkDerivation rec {
  name = "dexed";
  version = "0.9.4";
  src = fetchurl {
    url = "https://github.com/asb2m10/dexed/archive/v0.9.4hf1.tar.gz";
    sha256 = "04r76424f7d258hr4y7cfgjqb9m9b95kz9a7a31ggj8if4nx7yii";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    freeglut alsaLib curl openssl freetype libjack2 mesa
  ] ++ (with xorg; [
    libX11 libXcomposite libXcursor libXinerama libXrandr libXext
  ]);

  buildPhase = ''
    cd Builds/Linux
    make \
      CONFIG=Release \
      CXXFLAGS="-D JUCE_JACK=1 -D JUCE_ALSA -D buildVST=1 -D buildStandalone=1"

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
