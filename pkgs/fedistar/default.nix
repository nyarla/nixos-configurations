{ stdenv, lib, dpkg, fetchurl, autoPatchelfHook, glib-networking, openssl
, webkitgtk, wrapGAppsHook }:
stdenv.mkDerivation rec {
  name = "fedistar";
  version = "0.8.3";

  src = fetchurl {
    url =
      "https://github.com/h3poteto/fedistar/releases/download/v${version}/fedistar_${version}_amd64.deb";
    sha256 = "sha256-IS3aJiHLApc5A75XIKABAFCNp1H4hO4AIjDbnRX33Iw=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glib-networking openssl webkitgtk wrapGAppsHook ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
}
