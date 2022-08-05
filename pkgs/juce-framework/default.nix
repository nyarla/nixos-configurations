{ stdenv, fetchzip, pkgconfig, cmake, alsaLib, curl, doxygen, freetype, glib
, graphviz, gtk3, ladspa-sdk, libjack2, libjpeg_turbo, libpng, pcre, python3
, webkitgtk, zlib, xorg, libGLU }:
stdenv.mkDerivation rec {
  pname = "juce-framework";
  version = "7.0.1";
  src = fetchzip {
    url =
      "https://github.com/juce-framework/JUCE/archive/refs/tags/${version}.zip";
    sha256 = "0pwpa77i86bwlv8727qss633vn2584zmhanybn1lnbkrdx1qbpkj";
  };

  nativeBuildInputs = [ cmake pkgconfig doxygen python3 ];
  buildInputs = [
    alsaLib
    curl.dev
    freetype
    glib.dev
    graphviz
    gtk3
    ladspa-sdk
    libGLU
    libjack2
    libjpeg_turbo
    libpng
    pcre
    webkitgtk
    zlib
  ] ++ (with xorg; [
    libX11
    libXcomposite
    libXcursor
    libXext
    libXinerama
    libXrandr
    libXrender
  ]);

  cmakeFlags = [ "-DJUCE_BUILD_EXTRAS=ON" "-DJUCE_TOOL_INSTALL_DIR=bin" ];

  postInstall = ''
    install -vDm 755 extras/Projucer/Projucer_artefacts/Release/Projucer $out/bin/
    install -vDm 644 ../examples/Assets/juce_icon.png $out/share/icons/hicolor/512x512/apps/Projucer.png
  '';
}
