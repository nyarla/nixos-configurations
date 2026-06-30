{
  stdenv,
  lib,

  fetchurl,
  autoPatchelfHook,
  makeWrapper,

  asar,

  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  libGL,
  libappindicator-gtk3,
  libcap,
  libdbusmenu,
  libdrm,
  libgbm,
  libglvnd,
  libgpg-error,
  libjack2,
  libnotify,
  libsecret,
  libuuid,
  libxkbcommon,
  mesa,
  musl,
  nspr,
  nss,
  pango,
  systemd,
  unzip,
  zlib,

  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxcb,
  libxkbfile,
  libxshmfence,
}:
stdenv.mkDerivation rec {
  pname = "sononym";
  version = "1.6.12";

  src = fetchurl {
    url = "https://www.sononym.net/download/sononym-${version}.tar.bz2";
    hash = "sha256-Ot1DSqcFtNv+Tf58XfoCI2kY2fHOoj2eKmt953NqRCw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    asar
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig.out
    freetype
    gdk-pixbuf
    glib-networking.out
    glib.out
    gtk3
    libGL
    libappindicator-gtk3
    libcap
    libdbusmenu
    libdrm
    libgbm
    libglvnd
    libgpg-error
    libjack2
    libnotify
    libsecret
    libuuid.out
    libxkbcommon
    mesa
    musl
    nspr
    nss
    pango.out
    stdenv.cc.cc
    stdenv.cc.cc.lib
    stdenv.cc.libc
    systemd
    unzip
    zlib
  ]
  ++ [
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbfile
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
  ];

  libPath =
    lib.makeLibraryPath buildInputs + (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/opt/sononym
    cp -r . $out/opt/sononym

    chmod -R +w $out/opt
    asar e $out/opt/sononym/resources/app.asar $out/opt/sononym/resources/app
    rm $out/opt/sononym/resources/app.asar

    runHook postBuild
  '';

  dontStirp = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -sf $out/opt/sononym/sononym $out/bin/sononym

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/sononym \
    --prefix LD_LIBRARY_PATH : "${libPath}:$out/opt/sononym"
  '';
}
