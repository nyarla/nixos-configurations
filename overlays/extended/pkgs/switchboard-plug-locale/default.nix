{ stdenv
, fetchurl
, pkgconfig
, meson
, python3
, ninja
, gettext
, vala
, gtk3
, clutter-gtk
, libgee
, libunity
, accountsservice
, ibus
, gnome3
, pantheon
, polkit
, wrapGAppsHook
, gobject-introspection
}:
stdenv.mkDerivation rec {
  pname = "switchboard-plug-locale";
  version = "2.4.1";
  src = fetchurl {
    url = "https://github.com/elementary/switchboard-plug-locale/archive/2.4.1.tar.gz";
    sha256 = "02rd92v18xp8vhhmgxj3xcmz8hda7zgayrip6m2bc7rgr2f12m9l";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

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
    accountsservice
    ibus
    gnome3.gnome-desktop
    polkit
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  prePatch = ''
    cp ${./UbuntuInstallerShim.vala} src/Installer/UbuntuInstaller.vala
    sed -i "s:/usr/share/:${accountsservice}/share:g" src/Util.vala
  '';

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';
}
