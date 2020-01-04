{ stdenv, fetchurl, fetchgit, pkgconfig, gnused, gnutar, cmake,
freetype, fontconfig, xorg, cairo, gtkmm3, libxkbcommon, sqlite, libxcb, pcre, glib,
utillinux, libselinux, libsepol, epoxy, libjack2, atk, at-spi2-core, dbus, wineWowPackages }:
let
  vst3sdk = fetchgit {
    url = "https://github.com/steinbergmedia/vst3sdk";
    fetchSubmodules = true;
    sha256 = "0hqg5fl4xbrml4kr4mgbxxk8hnhags0f5lwb0m17nbajbksgan58";
  };
in stdenv.mkDerivation rec {
  name = "linvst3";
  version = "1.8";
  src = fetchurl {
    url = "https://github.com/osxmidi/LinVst3/archive/1.8.tar.gz";
    sha256 = "157pikv8am2b6xdpjpp4yczqgc6a4dpssmvq3f7r6181n4c53mff";
  };
  
  buildInputs = [
    freetype libxkbcommon gtkmm3 sqlite fontconfig cairo wineWowPackages.staging atk.dev at-spi2-core.dev
    libxcb pcre glib.dev libjack2 utillinux.dev libselinux libsepol epoxy dbus.dev
  ] ++ (with xorg; [
    libX11 xcbutil xcbutilcursor xcbutilimage xcbutilerrors
    xcbutilkeysyms libpthreadstubs
    libXdmcp xcbutilrenderutil
    libXtst
  ]);

  dontUseCmakeConfigure = true;
  
  unpackPhase = ''
    cp -R ${vst3sdk} vst3sdk
    chmod -R +w vst3sdk
    tar -zxvf ${src} -C .
    mv LinVst3-1.8 vst3sdk/LinVST3
    cd vst3sdk/LinVST3
  '';

  nativeBuildInputs = [ gnused cmake pkgconfig ];
  
  patchPhase = ''
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst!" Makefile
    sed -i "s!/usr/lib/x86_64-linux-gnu/wine-development!${wineWowPackages.staging}/include/wine!" Makefile
    sed -i "s!/usr/include/wine-development!${wineWowPackages.staging}/include/wine!g" lin-patchwin
    sed -i "s!/usr/bin/wine!${wineWowPackages.staging}/bin/wine!g" lin-patchwin
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
    sed -i 's!file(MAKE_DIRECTORY ''${SMTG_PLUGIN_TARGET_PATH})!!' ../cmake/modules/AddVST3Options.cmake
    sed -i 's!/bin/bash!${stdenv.shell}!' ../vstgui4/vstgui/uidescription/editing/createuidescdata.sh
    sed -i 's!#include <processthreadsapi.h>!!' ../public.sdk/source/common/threadchecker_win32.cpp
  '';
}
