{
  libsForQt5,
  fetchpatch,
  xorg,
}:
libsForQt5.plasma-workspace.overrideAttrs (old: rec {
  pname = "xembed-sni-proxy";
  inherit (old) version;

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/cmake.patch?h=xembed-sni-proxy-git";
      sha256 = "1nas6kdxprcvcj3d9p59jp6rqgfnvkkm2g28x9hp2ydydbgi4hmk";
    })
  ];

  postPatch = ''
    sed -i 's|s_embedSize = 32;|s_embedSize = 1;|' xembed-sni-proxy/sniproxy.cpp
  '';

  buildInputs = [
    libsForQt5.qt5.qtx11extras
    libsForQt5.kwin
    xorg.libXdmcp
    xorg.libXtst
  ];

  srcRoot = "xembed-sni-proxy";
  configurePhase = ''
    cd xembed-sni-proxy
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DBUILD_TESTING=OFF \
      .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';

  postFixup = "";
})
