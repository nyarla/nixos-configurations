{ stdenv, lib, ibus, python3, fetchurl, wrapGAppsHook, gobjectIntrospection }:
stdenv.mkDerivation rec {
  pname = "ibus-mode-we";
  version = "v1.1";
  src = fetchurl {
    url = "https://github.com/clear-code/ime-mode-we/releases/download/v1.1/ime-mode-we-host.tar.gz";
    sha256 = "13wlw3p64n62mxkddmw8wn46s101gamcl01f34kqi9l91g8sglpm";
  };

  nativeBuildInputs = [
    wrapGAppsHook python3.pkgs.wrapPython gobjectIntrospection
  ];

  buildInputs = [
    python3.pkgs.pygobject3 ibus.out
  ];

  pythonPath = [ python3.pkgs.pygobject3 ibus.out ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    
    cp lib/mozilla/native-messaging-hosts/com.clear_code.ime_mode_we_host.json \
      $out/lib/mozilla/native-messaging-hosts/com.clear_code.ime_mode_we_host.json

    cp local/bin/* $out/bin
  '';
  
  preFixup = ''
    chmod +x $out/bin/*

    sed -i "s|#!/bin/sh|#!${python3}/bin/python|" $out/bin/ime-mode-we
    sed -i "s|/usr/local/bin|$out/bin|" $out/bin/ime-mode-we 

    sed -i "s|#!/bin/sh|#!${python3}/bin/python|" $out/bin/ibus-set-input-mode

    sed -i "s|/usr/local/bin|$out/bin|" $out/lib/mozilla/native-messaging-hosts/com.clear_code.ime_mode_we_host.json

    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';
}
