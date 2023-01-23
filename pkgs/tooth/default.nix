{ stdenv, lib, fetchFromGitHub, wrapGAppsHook, meson, ninja, vala, pkg-config
, glib, json-glib, libgee, gnome3, gtk4, libadwaita, libsecret
, desktop-file-utils }:
stdenv.mkDerivation rec {
  pname = "tooth";
  version = "2023-01-20";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tooth";
    rev = "ea4f976cf0bb194bb046df99a4200d0ca65e49c4";
    sha256 = "sha256-owUbCKZAThOSK2c0dfqApfOslcKX+zcx3yGvQmoVp3o=";
  };

  buildInputs = [
    glib.dev
    gnome3.libsoup
    gtk4.dev
    json-glib
    libadwaita
    libgee
    libsecret.dev
  ];

  nativeBuildInputs =
    [ meson ninja vala pkg-config wrapGAppsHook desktop-file-utils ];
}
