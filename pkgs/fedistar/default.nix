{ stdenv, dpkg, fetchurl, autoPatchelfHook, glib-networking, openssl, webkitgtk
, wrapGAppsHook }:
stdenv.mkDerivation rec {
  name = "fedistar";
  version = "1.3.4";

  src = fetchurl {
    url =
      "https://github.com/h3poteto/fedistar/releases/download/v${version}/fedistar_${version}_amd64.deb";
    sha256 = "sha256-93lpSoSIZyQrbi9DqI599Us8AKAs6tBAix6buMt65eA=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glib-networking openssl webkitgtk wrapGAppsHook ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
}
