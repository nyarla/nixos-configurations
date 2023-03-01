{ stdenv, lib, dpkg, fetchurl, autoPatchelfHook, glib-networking, openssl
, webkitgtk, wrapGAppsHook }:
stdenv.mkDerivation rec {
  name = "fedistar";
  version = "1.0.0-beta1";

  src = fetchurl {
    url =
      "https://github.com/h3poteto/fedistar/releases/download/v1.0.0-beta.1/fedistar_1.0.0_amd64.deb";
    sha256 = "1bfsj95d0bdvkz8ckdbzfng84x4lrf0d66mnfs9v3bx1kfgndvf2";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glib-networking openssl webkitgtk wrapGAppsHook ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
}
