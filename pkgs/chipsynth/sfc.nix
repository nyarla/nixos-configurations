{
  sources,

  stdenvNoCC,
  stdenv,
  autoPatchelfHook,

  dpkg,
  unzip,

  alsa-lib,
  cairo,
  curl,
  fontconfig,
  gdk-pixbuf,
  glib-networking,
  glibmm_2_4,
  gtk3,
  gtkmm3,
  libpng,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-util,
  libxkbcommon,
  pango,
  pulseaudio,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chipsynth-sfc";
  version = "1.132";
  src = sources.chipsynth-sfc;

  unpackPhase = ''
    runHook preUnpack

    unzip ${finalAttrs.src}

    runHook postUnpack
  '';

  sourceRoot = "LINUX_plogue-${finalAttrs.pname}_${finalAttrs.version}_x86_64";

  installPhase = ''
    runHook preInstall

    ls -lah .
    dpkg -x plogue-chipsynth-sfc_1.132_amd64.deb unpack
    dpkg -x plogue-fermata_2.132_amd64.deb unpack

    mkdir -p $out/
    cp -r unpack/usr/* $out/
    cp -r unpack/opt   $out/opt

    runHook postInstall
  '';

  buildInputs = [
    alsa-lib
    cairo
    curl
    fontconfig
    gdk-pixbuf
    glib-networking
    glibmm_2_4
    gtk3
    gtkmm3
    libpng
    libx11
    libxcb
    libxcb-cursor
    libxcb-util
    libxkbcommon
    pango
    pulseaudio
    stdenv.cc.libc
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    unzip
  ];
})
