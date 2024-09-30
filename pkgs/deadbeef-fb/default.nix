{
  stdenv,
  fetchFromGitLab,
  pkg-config,
  deadbeef,
  gtk3,
  autoconf,
  automake,
  libtool,
  glib,
}:
stdenv.mkDerivation rec {
  pname = "deadbeef-fb";
  version = "git";
  src = fetchFromGitLab {
    owner = "zykure";
    repo = "deadbeef-fb";
    rev = "17accd5345adeb3b81315d284dd81ac881517cc6";
    hash = "sha256-xmC0m47OnEQS4nXRG+bq5vMiAui0+ehhCrcWF8n1t/s=";
  };
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
