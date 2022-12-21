{ stdenv, fetchurl, buildFHSUserEnv, writeShellScript }:
let
  pkg = stdenv.mkDerivation rec {
    pname = "sononym";
    version = "1.4.2";
    src = fetchurl {
      url = "https://www.sononym.net/download/sononym-1.4.2.tar.bz2";
      sha256 = "08xwplvma4vvhkwcdwx2b1gy01mcgcdd7mgw2nz2cbdxq4rq9w08";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/sononym 
      cp -R . $out/share/sononym/
    '';
  };
in buildFHSUserEnv rec {
  name = "sononym";
  targetPkgs = pkgs:
    with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libappindicator-gtk3
      libcap
      libdbusmenu
      libdrm
      libglvnd
      libgpg-error
      libjack2
      libnotify
      libsecret
      libuuid
      libxkbcommon
      mesa
      nspr
      nss
      pango
      stdenv.cc.cc
      systemd
      unzip
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      zlib
    ];
  runScript = writeShellScript "sononym-bin.sh" ''
    exec -a "''${0}" ${pkg}/share/sononym/sononym "$@" 
  '';
}
