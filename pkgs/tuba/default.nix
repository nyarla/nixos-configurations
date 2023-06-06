{ stdenv, fetchFromGitHub, wrapGAppsHook, meson, ninja, vala, pkg-config, glib
, json-glib, libgee, gnome3, gtk4, libadwaita, libsecret, gtksourceview5
, desktop-file-utils, libsoup_3 }:
stdenv.mkDerivation rec {
  pname = "Tuba";
  version = "2023-04-06";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "b06835af3ca883e407a88cd47e79e9c78bbe0168";
    sha256 = "sha256-egVnbvAN7/On7FNKbx1ace/an4MvF+5YMgj4WAvUR+w=";
  };

  buildInputs = [
    glib.dev
    gnome3.libsoup
    gtk4.dev
    gtksourceview5
    json-glib
    libadwaita
    libgee
    libsecret.dev
    libsoup_3.dev
  ];

  nativeBuildInputs =
    [ meson ninja vala pkg-config wrapGAppsHook desktop-file-utils ];
}
