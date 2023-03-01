{ stdenv, lib, fetchFromGitHub, wrapGAppsHook, meson, ninja, vala, pkg-config
, glib, json-glib, libgee, gnome3, gtk4, libadwaita, libsecret
, desktop-file-utils }:
stdenv.mkDerivation rec {
  pname = "tooth";
  version = "2023-01-20";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tooth";
    rev = "b7155df0ce7ea245fb443ee0a0946b9051987241";
    sha256 = "sha256-XlgNAkCyvCTQjZwskvEAHRw9eADRM2WpJ4eeOHFBtzA=";
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
