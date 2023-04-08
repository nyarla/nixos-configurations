{ stdenv, lib, fetchFromGitHub, wrapGAppsHook, meson, ninja, vala, pkg-config
, glib, json-glib, libgee, gnome3, gtk4, libadwaita, libsecret, gtksourceview5
, desktop-file-utils, libsoup_3 }:
stdenv.mkDerivation rec {
  pname = "Tuba";
  version = "2023-04-06";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "85e8c02b387a30f0d3627cb7d95def456f64d796";
    sha256 = "sha256-LPhGGIHvN/hc71PL50TBw1Q0ysubdtJaEiUEI29HRrE=";
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
