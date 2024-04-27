{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
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
  gtk3,
  libappindicator-gtk3,
  libcap,
  libdbusmenu,
  libdrm,
  libglvnd,
  libgpg-error,
  libjack2,
  libnotify,
  libsecret,
  libuuid,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  unzip,
  xorg,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "sononym";
  version = "1.5.5";

  src = fetchurl {
    url = "https://www.sononym.net/download/sononym-${version}.tar.bz2";
    sha256 = "0ffhrjzb3n9jajlgkckf52lif9ljgb6i8cv1p6xkrhcmng7dsf6m";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs =
    [
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
      glib.out
      gtk3
      libappindicator-gtk3
      libcap
      libdbusmenu
      libdrm
      libglvnd
      libgpg-error
      libjack2
      libnotify
      libsecret
      libuuid.out
      libxkbcommon
      mesa
      nspr
      nss
      pango.out
      stdenv.cc.cc
      stdenv.cc.libc
      stdenv.cc.cc.lib
      systemd
      unzip
      zlib
    ]
    ++ (with xorg; [
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libxcb
      libxkbfile
      libxshmfence
    ]);

  libPath =
    lib.makeLibraryPath buildInputs + (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/opt/sononym
    cp -r . $out/opt/sononym

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
