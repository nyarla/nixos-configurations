{
  stdenvNoCC,
  autoPatchelfHook,
  fetchurl,
  wrapGAppsHook,

  flutter,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  harfbuzz,
  libsecret,
}:
stdenvNoCC.mkDerivation rec {
  pname = "aria-bin";
  version = "v0.14.4";
  src = fetchurl {
    url = "https://github.com/poppingmoon/aria/releases/download/v0.14.4/aria-v0.14.4-linux-x64.tar.gz";
    sha256 = "04scrpmgjw50nv7srs6gffdxs6sbrr0p8mf0hinrhij5v53x1hlz";
  };

  unpackPhase = ''
    tar -zxvf ${src}
  '';

  sourceRoot = ".";

  buildInputs = [
    flutter
    gtk3
    gdk-pixbuf
    harfbuzz
    gobject-introspection
    glib
    libsecret
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/libexec
    mkdir -p $out/bin

    mv aria $out/libexec/aria
    mv data $out/libexec/data
    mv lib  $out/libexec/lib

    cat <<... >$out/bin/aria
    #!${stdenvNoCC.shell}
    export LD_LIBRARY_PATH=$out/libexec/lib:\$LD_LIBRARY_PATH
    exec $out/libexec/aria "''${@:-}"
    ...

    chmod +x $out/bin/aria
  '';
}
