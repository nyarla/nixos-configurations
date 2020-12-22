{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, python3, ninja, vala
, gtk3, libgee, gettext, clutter-gtk, libunity, gnome2, polkit, wrapGAppsHook
, gobject-introspection }:
stdenv.mkDerivation rec {
  pname = "elementary-tweaks";
  version = "git";
  src = fetchFromGitHub {
    owner = "elementary-tweaks";
    repo = pname;
    rev = "47574c8b64e1d362db5055b82334717515977a73";
    sha256 = "1njl51bh7asx5vf806wgs5fp525fdn2kdsvp8f0qhlcws5zkvikh";
  };

  passthru = { updateScript = pantheon.updateScript { repoName = pname; }; };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.switchboard
    pantheon.granite
    pantheon.elementary-icon-theme
    clutter-gtk
    gtk3
    libgee
    libunity
    gnome2.GConf
    polkit
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';
}
