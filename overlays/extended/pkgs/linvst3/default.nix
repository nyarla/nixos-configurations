{ stdenv, fetchFromGitHub, fetchgit, pkgconfig, gnused, gnutar, cmake, freetype
, fontconfig, xorg, cairo, gtkmm3, libxkbcommon, sqlite, libxcb, pcre, glib
, utillinux, libselinux, libsepol, epoxy, libjack2, atk, at-spi2-core, dbus
, wineWowPackages }:
let
  vst3sdk = fetchgit {
    url = "https://github.com/steinbergmedia/vst3sdk";
    fetchSubmodules = true;
    sha256 = "0hqg5fl4xbrml4kr4mgbxxk8hnhags0f5lwb0m17nbajbksgan58";
  };
in stdenv.mkDerivation rec {
  name = "linvst3";
  version = "1.8";
  src = fetchFromGitHub {
    owner = "osxmidi";
    repo = "LinVst3";
    rev = "59e9facbbc1670af83b3e5eb402589bba2d3f232";
    sha256 = "1ci22d5cp0cx68hkb5248689a05dr2pqkyxg387iip91885kn6rf";
  };

  buildInputs = [
    freetype
    libxkbcommon
    gtkmm3
    sqlite
    fontconfig
    cairo
    wineWowPackages.staging
    atk.dev
    at-spi2-core.dev
    libxcb
    pcre
    glib.dev
    libjack2
    utillinux.dev
    libselinux
    libsepol
    epoxy
    dbus.dev
  ] ++ (with xorg; [
    libX11
    xcbutil
    xcbutilcursor
    xcbutilimage
    xcbutilerrors
    xcbutilkeysyms
    libpthreadstubs
    libXdmcp
    xcbutilrenderutil
    libXtst
  ]);

  dontUseCmakeConfigure = true;

  unpackPhase = ''
    cp -R ${vst3sdk} vst3sdk
    chmod -R +w vst3sdk
    mkdir -p vst3/LinVST3
    cp -R ${src} vst3sdk/LinVST3
    cd vst3sdk/LinVST3
    chmod -R +w .
  '';

  nativeBuildInputs = [ gnused cmake pkgconfig ];

  patchPhase = ''
    sed -i "s!/usr!$out!" Makefile
    sed -i "s!./vst!$out/lib/vst-wine!" Makefile
    sed -i "s!/usr/bin/wine!${wineWowPackages.staging}/bin/wine!g" lin-patchwin
    sed -i "s!/usr/bin!$out/bin!g" remotevstclient.cpp
    sed -i 's!file(MAKE_DIRECTORY ''${SMTG_PLUGIN_TARGET_PATH})!!' ../cmake/modules/AddVST3Options.cmake
    sed -i 's!/bin/bash!${stdenv.shell}!' ../vstgui4/vstgui/uidescription/editing/createuidescdata.sh
    sed -i 's!#include <processthreadsapi.h>!!' ../public.sdk/source/common/threadchecker_win32.cpp
  '';
}
