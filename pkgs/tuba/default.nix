{ stdenv, fetchFromGitHub, wrapGAppsHook, meson, ninja, vala, pkg-config, glib
, json-glib, libgee, gnome3, gtk4, libadwaita, libsecret, gtksourceview5
, desktop-file-utils, libsoup_3 }:
stdenv.mkDerivation rec {
  pname = "Tuba";
  version = "2023-04-06";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "283ea9b15f8ad7f36faf4fcbc7a15dcb28a12c2f";
    sha256 = "sha256-36OvbK8CdnFH+MpuMC+XID2XRxFWtHDWEhwq2Gt60z4=";
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
