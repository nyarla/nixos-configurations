{ multiStdenv, fetchzip, fetchurl, pkgsi686Linux, xorg, wineWowPackages, gnused, file }:
let
  vst2sdk = fetchzip {
    url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
    sha256 = "1x4qfviwcssk4fswhqks745jicblpy352kd69p7cqmgfcxhckq79";
  };
in
multiStdenv.mkDerivation rec {
  name = "vst-bridge";
  version = "git";
  src = fetchurl {
    url = "https://github.com/abique/vst-bridge/archive/master.tar.gz";
    sha256 = "1wbshll69f55f7c23vawd3jq3zj9dfln0q2p78kr6qikamcsz3ws";
  };

  postPatch = ''
    sed -i 's|#! /bin/bash|#!${multiStdenv.shell}|' configure
    cp -R ${vst2sdk}/* vstsdk2.4/

    sed -i 's!PATH_MAX!8192!g' maker/maker.c
    sed -i 's!PATH_MAX!8192!g' plugin/plugin.cc
  '';

  buildInputs = [
    xorg.libX11
    xorg.libXcomposite
    wineWowPackages.staging
    file
    pkgsi686Linux.xorg.libX11
    pkgsi686Linux.xorg.libXcomposite
  ];

  nativeBuildInputs = [ gnused ];

  configurePhase = ''
    ./configure --prefix=$out
  '';
}
