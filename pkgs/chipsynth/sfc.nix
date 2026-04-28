{
  stdenvNoCC,
  stdenv,
  autoPatchelfHook,
  fetchzip,

  dpkg,

  alsa-lib,
  cairo,
  curl,
  fontconfig,
  gdk-pixbuf,
  glib-networking,
  glibmm,
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
stdenvNoCC.mkDerivation {
  pname = "chipsynth-sfc";
  version = "1.124-beta.1";
  src = fetchzip {
    name = "chipsynth-sfc";
    url = "https://chipsynth.s3.us-east-1.amazonaws.com/LINUX_plogue-chipsynth-sfc_1.124~beta1_x86_64.zip";
    sha256 = "1qlwfavwbdy6675sy35sa8d7pjyd824jb3xm3svdi17cmy349ck9";
  };

  installPhase = ''
    ls -lah .
    dpkg -x plogue-chipsynth-sfc_1.124~beta1_amd64.deb unpack
    dpkg -x plogue-fermata_2.124~beta1_amd64.deb unpack

    mkdir -p $out/
    cp -r unpack/usr/* $out/
    cp -r unpack/opt   $out/opt
  '';

  buildInputs = [
    alsa-lib
    cairo
    curl
    fontconfig
    gdk-pixbuf
    glib-networking
    glibmm
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
  ];
}
