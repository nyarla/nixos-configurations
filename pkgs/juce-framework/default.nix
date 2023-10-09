{ stdenv, fetchFromGitHub, pkg-config, cmake, alsa-lib, curl, doxygen, freetype
, glib, graphviz, gtk3, ladspa-sdk, libjack2, libjpeg_turbo, libpng, pcre
, python3, webkitgtk, zlib, xorg, libGLU }:
stdenv.mkDerivation rec {
  pname = "juce-framework";
  version = "7.0.7";
  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "JUCE";
    rev = "22df0d2266007bccb25d6ed52b9907f60d04e971";
    hash = "sha256-/NiZI45fzZDcKaIT4C1hf3F5Nqy6qFOjPXlrmZOEbLE=";
  };

  nativeBuildInputs = [ cmake pkg-config doxygen python3 ];
  buildInputs = [
    alsa-lib
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
