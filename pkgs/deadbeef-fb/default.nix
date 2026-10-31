{
  sources,

  stdenv,
  pkg-config,
  deadbeef,
  gtk3,
  autoconf,
  automake,
  libtool,
  glib,
}:
stdenv.mkDerivation {
  pname = "deadbeef-fb";
  version = "git";
  src = sources.deadbeef-fb;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];
  buildInputs = [
    deadbeef
    glib
    gtk3
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--prefix=$(out)"
    "--disable-gtk2"
  ];
}
