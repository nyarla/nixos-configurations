{ stdenv, fetchurl
, avahi, sqlite, ffmpeg, minixml, protobufc, json_c, zlib, libgcrypt, libgpgerror, libuv
, libconfuse, libevent, libunistring, libplist, libantlr3c, libsodium, libwebsockets
, openssl, alsaLib, curl, libpulseaudio 
, gperf, antlr3_5, pkgconfig
}:
stdenv.mkDerivation rec {
  name    = "forked-daapd";
  version = "26.5";
  src     = fetchurl {
    url     = "https://github.com/ejurgensen/forked-daapd/releases/download/${version}/forked-daapd-${version}.tar.xz";
    sha256  = "0g4j0mm5qaij36rd75x90l3dh8rvghr6b2m02dj41zvqq30ya4kd";
  };

  buildInputs = [
    avahi sqlite ffmpeg minixml protobufc json_c zlib libgcrypt libgpgerror libuv
    libconfuse libevent libunistring libplist libantlr3c libsodium libwebsockets
    openssl alsaLib curl libpulseaudio
  ];

  nativeBuildInputs = [
    gperf antlr3_5 pkgconfig
  ];
}
