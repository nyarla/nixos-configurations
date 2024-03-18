{ libsForQt5, fetchpatch }:
libsForQt5.plasma-workspace.overrideAttrs (old: rec {
  pname = "xembed-sni-proxy";
  inherit (old) version;

  patches = [
    (fetchpatch {
      url =
        "https://aur.archlinux.org/cgit/aur.git/plain/cmake.patch?h=xembed-sni-proxy-git";
      sha256 = "1nas6kdxprcvcj3d9p59jp6rqgfnvkkm2g28x9hp2ydydbgi4hmk";
    })
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

})
