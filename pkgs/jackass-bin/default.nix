{ stdenv, fetchurl, patchelf, wine, libjack2, wine-vst-wrapper }:
stdenv.mkDerivation rec {
  pname = "JackAss";
  version = "v1.1";
  src = fetchurl {
    url =
      "https://github.com/falkTX/${pname}/releases/download/v1.1/${pname}-${version}_wine64.tar.gz";
    sha256 = "sha256-VN//OK37BQI9MVRRRiPl17F24kxf4DnPtYQ29WdjPAk=";
  };

  buildPhase = ''
    for dll in JackAss*Wine64.dll ; do
      patchelf --add-needed libjack.so.0.1.0 $dll
      patchelf \
        --set-rpath "${libjack2}/lib:${stdenv.cc.cc.lib}/lib:${wine}/lib/wine/x86_64-unix" \
        $dll
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/winvst/JackAss

    cp JackAssWine64.dll $out/lib/winvst/JackAss/JackAss64.dll.so
    cp JackAssFxWine64.dll $out/lib/winvst/JackAss/JackAssFx64.dll.so

    cp ${wine-vst-wrapper}/share/wine-vst-wrapper/vst.dll \
      $out/lib/winvst/JackAss/JackAss64.dll

    cp ${wine-vst-wrapper}/share/wine-vst-wrapper/vst.dll \
      $out/lib/winvst/JackAss/JackAssFx64.dll
  '';
}
