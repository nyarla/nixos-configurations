{ stdenv
, fetchurl
, pkgconfig
, intltool
, vala
, wrapGAppsHook
, gobjectIntrospection
, glib
, dbus-glib
, gnome3
, ibus
, libskk
, gtk2
, gtk3
, python3
}:
stdenv.mkDerivation rec {
  version = "1.4.3";
  name = "ibus-skk-${version}";
  src = fetchurl {
    url = "https://github.com/ueno/ibus-skk/releases/download/ibus-skk-1.4.3/ibus-skk-1.4.3.tar.xz";
    sha256 = "0pb5766njjsv0cfikm0j5sq0kv07sd5mlxj1c06k5y6p1ffvsqb6";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/fujiwarat/ibus-skk/commit/0336d99e0987f7a9efa45578674cda7cbda235d5.patch";
      sha256 = "0lcvhkfj7fq3nnb4r89l2pkprvqykbq7nayphh5vym2dy4kp79y1";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
    vala
    python3.pkgs.wrapPython
    wrapGAppsHook
    gobjectIntrospection
  ];

  buildInputs = [
    glib
    dbus-glib
    gtk2
    gtk3
    libskk
    gnome3.dconf
    gnome3.libgee
    ibus
  ];

  postPatch = ''
    sed -i "s!<layout>jp</layout>!<layout>us</layout>!" src/skk.xml.in.in
  '';

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/${name}/glib-2.0/schemas/
    cp src/org.freedesktop.ibus.engine.skk.gschema.xml $out/share/gsettings-schemas/${name}/glib-2.0/schemas/
  '';

  postFixup = "wrapPythonPrograms";

  meta = {
    isIbusEngine = true;
  };
}
