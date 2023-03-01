{ stdenv, lib, dpkg, fetchurl, autoPatchelfHook, glib-networking, openssl
, webkitgtk, wrapGAppsHook }:
stdenv.mkDerivation rec {
  name = "elk-native";
  version = "0.4.0";

  src = fetchurl {
    url =
      "https://github.com/elk-zone/elk-native/releases/download/elk-native-v0.4.0/Elk_0.4.0_linux_x86_64.deb";
    sha256 = "0linkm7li77qhq54wvjiva1625m6kdgmrs9wgcp01p3sxrkpxhj0";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glib-networking openssl webkitgtk wrapGAppsHook ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
}
