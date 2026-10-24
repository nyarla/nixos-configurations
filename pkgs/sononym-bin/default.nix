{
  sources,

  buildFHSEnv,
  fetchurl,
  lib,

  stdenv,
}:
let
  fhsEnv = buildFHSEnv {
    name = "sononym-env";
    targetPkgs =
      p: with p; [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        expat
        fontconfig.out
        freetype
        gdk-pixbuf
        glib-networking.out
        glib.out
        gtk3
        libGL
        libappindicator-gtk3
        libcap
        libdbusmenu
        libdrm
        libgbm
        libglvnd
        libgpg-error
        libjack2
        libnotify
        libsecret
        libuuid.out
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxkbcommon
        libxkbfile
        libxrandr
        libxrender
        libxscrnsaver
        libxshmfence
        libxtst
        mesa
        musl
        nspr
        nss
        pango.out
        pipewire
        pulseaudioFull
        stdenv.cc.cc
        stdenv.cc.cc.lib
        stdenv.cc.libc
        systemd
        unzip
        zlib
      ];
  };
in

stdenv.mkDerivation {
  pname = "sononym";
  version = "1.6.15";

  src = fetchurl {
    inherit (sources.sononym-bin) url hash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/sononym
    cp -r . $out/opt/sononym/

    mkdir -p $out/bin
    cat <<... >$out/bin/sononym
    #!${stdenv.shell}
    ${lib.getExe' fhsEnv "sononym-env"} -c 'exec -a sononym $out/opt/sononym/sononym "\''${@:-}"'
    ...
    chmod +x $out/bin/sononym

    runHook postInstall
  '';

  dontStrip = true;
}
