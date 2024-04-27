{
  stdenv,
  fetchurl,
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
  src = fetchurl {
    url = "https://gitlab.com/zykure/deadbeef-fb/-/archive/master/deadbeef-fb-master.tar.gz";
    sha256 = "1m78gd9paxw0182n5xsjzb8fxq90dq1izgff0fgxcx72fbgkvxzx";
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

  postPatch = ''
    sed -i "s/errno/errorNum/g" utils.c
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--prefix=$(out)"
    "--disable-gtk2"
  ];
}
