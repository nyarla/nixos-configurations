{ stdenv, buildFHSUserEnv, fetchurl, writeScript }:
let
  tateditor = stdenv.mkDerivation rec {
    name = "tateditor-bin-${version}";
    version = "3.3.17";
    src = fetchurl {
      url =
        "https://drive.google.com/uc?export=download&id=1nIb3ocWZp7y5NwQt4K_M1F8G_r1YjMdg";
      name = "tateditor-gtk3-x86_64.tar.gz";
      sha256 = "1h1x0iniqv05bhnvdicic1wpipsgq1mxk4b0pqfw35a1rplr3pln";
    };

    dontFixup = true;

    installPhase = ''
      mkdir -p $out/libexec
      cp -p tateditor $out/libexec/tateditor
      chmod +x $out/libexec/tateditor
    '';
  };
in buildFHSUserEnv rec {
  name = "tateditor";
  targetPkgs = pkgs:
    (with pkgs; [ libuuid zlib glib pango cairo gdk_pixbuf fontconfig ])
    ++ (with pkgs.xorg; [ libX11 libXxf86vm libSM ]);

  runScript = writeScript "tateditor" ''
    #!${stdenv.shell}

    if test ! -d $HOME/.config/tateditor ; then
      mkdir -p $HOME/.config/tateditor
    fi

    if test ! -e $HOME/.config/tateditor/tateditor \
    || test "$(cat $HOME/.config/tateditor/version)" != "${tateditor.version}"; then
      test ! -e $HOME/.config/tateditor/tateditor || chmod +r $HOME/.config/tateditor/tateditor
      cp ${tateditor}/libexec/tateditor $HOME/.config/tateditor/tateditor
      chmod +x $HOME/.config/tateditor/tateditor
      echo "${tateditor.version}" >$HOME/.config/tateditor/version
    fi

    export GDK_SCALE=1
    export GDK_DPI_SCALE=1
    exec "$HOME/.config/tateditor" "''${@:-}" 2>/dev/null
  '';
}
