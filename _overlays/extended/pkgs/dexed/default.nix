{ gcc7Stdenv, fetchurl, pkgconfig, freeglut, alsaLib, curl, openssl, freetype
, libjack2, xorg, mesa }:
gcc7Stdenv.mkDerivation rec {
  name = "dexed";
  version = "0.9.4";
  src = fetchurl {
    url = "https://github.com/asb2m10/dexed/archive/v0.9.4.tar.gz";
    sha256 = "0vv6gry8va7cd3rk6z79xvddb1as2iccx0bjv833qgwzrgc431v2";
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
