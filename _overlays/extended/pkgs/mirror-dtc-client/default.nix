{ stdenv, lib, requireFile, unzip, patchelf, xorg, gtkmm3, atkmm, pangomm
, cairomm, glibmm, glib, gtk3, gdk_pixbuf, libsigcxx, expat, zlib, libdrm
, libpulseaudio }:
stdenv.mkDerivation rec {
  name = "mirror-dtc-client-${version}";
  version = "1.3.1";

  src = requireFile {
    name = "MirrorDTC_U131.zip";
    sha256 = "1i3s7sxb4y7vqsql0d1k400cqy1pmjmh3zvcpy9bmi8779n0kyh3";
    url = "http://t-ishii.la.coocan.jp/hp/mc/index.html";
  };

  nativeBuildInputs = [ unzip patchelf ];

  buildInputs = (with xorg; [
    libpthreadstubs
    libxcb
    libxshmfence
    libXdamage
    libXfixes
    libX11
    libXxf86vm
    libXext
    libXau
    libXdmcp
  ]) ++ [
    gtkmm3
    atkmm
    pangomm
    cairomm
    glib
    glibmm
    gtk3
    gdk_pixbuf
    libsigcxx
    zlib
    libdrm
    libpulseaudio
    stdenv.cc.cc
  ];

  libPath = (lib.makeLibraryPath buildInputs) + ":/run/opengl-driver/lib";

  unpackPhase = ''
    unzip ${src}
  '';

  dontStrip = true;
  dontPatchelf = true;

  installPhase = ''
    mkdir -p $out/bin
    cp MirrorDTC_U131/Client/bin/MCClient.ini      $out/bin
    cp MirrorDTC_U131/Client/bin/mcclientu1604_64  $out/bin/mcclient

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} \
      $out/bin/mcclient
  '';
}
