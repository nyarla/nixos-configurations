{ stdenv
, lib
, fetchurl
, callPackage
, substituteAll
, python3
, pkgconfig
, xorg
, gtk3
, glib
, glib-networking
, pango
, cairo
, gdk-pixbuf
, atk
, xorgserver
, getopt
, xauth
, utillinux
, which
, ffmpeg_4
, x264
, libvpx
, libwebp
, x265
, libfakeXinerama
, wrapGAppsHook
, dbus
, gst_all_1
, pulseaudio
, gobject-introspection
, buildFHSUserEnv
, writeScript
, pam
}:

with lib;
let
  inherit (python3.pkgs) cython buildPythonPackage;

  xf86videodummy = callPackage <nixpkgs/pkgs/tools/X11/xpra/xf86videodummy> { };

  xpra = buildPythonPackage rec {
    pname = "xpra";
    version = "2.5.3";

    src = fetchurl {
      url = "https://xpra.org/src/${pname}-${version}.tar.xz";
      sha256 = "1ys35lj28903alccks9p055psy1fsk1nxi8ncchvw8bfxkkkvbys";
    };

    patches = [
      (substituteAll {
        src = <nixpkgs/pkgs/tools/X11/xpra/fix-paths.patch>;
        inherit (xorg) xkeyboardconfig;
      })
    ];

    postPatch = ''
      substituteInPlace setup.py --replace '/usr/include/security' '${pam}/include/security'
    '';

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = with xorg; [
      libX11
      xorgproto
      libXrender
      libXi
      libXtst
      libXfixes
      libXcomposite
      libXdamage
      libXrandr
      libxkbfile
    ] ++ [
      cython

      pango
      cairo
      gdk-pixbuf
      atk.out
      gtk3
      glib

      ffmpeg_4
      libvpx
      x264
      libwebp
      x265

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav

      pam
      gobject-introspection
    ];
    propagatedBuildInputs = with python3.pkgs; [
      pillow
      rencode
      pycrypto
      cryptography
      pycups
      lz4
      dbus-python
      netifaces
      numpy
      pygobject3
      pycairo
      gst-python
      pam
      pyopengl
      paramiko
      opencv4
      python-uinput
      pyxdg
      ipaddress
      idna
    ];

    # error: 'import_cairo' defined but not used
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

    setupPyBuildFlags = [
      "--with-Xdummy"
      "--without-strict"
      "--with-gtk3"
      "--without-gtk2"
      # Override these, setup.py checks for headers in /usr/* paths
      "--with-pam"
      "--with-vsock"
    ];

    doCheck = false;
    dontWrapPythonPrograms = true;
    enableParallelBuilding = true;

    passthru = { inherit xf86videodummy; };

    meta = {
      homepage = http://xpra.org/;
      downloadPage = "https://xpra.org/src/";
      downloadURLRegexp = "xpra-.*[.]tar[.]xz$";
      description = "Persistent remote applications for X";
      platforms = platforms.linux;
      license = licenses.gpl2;
      maintainers = with maintainers; [ tstrobel offline numinit ];
    };
  };

  dbus-launch = stdenv.mkDerivation rec {
    name = "dbus-launch";
    buildCommand = ''
      mkdir -p $out/bin
      echo -e "#!${stdenv.shell}\nexec ${dbus.lib}/bin/dbus-launch --config-file=/host/etc/dbus-1/session.conf \"\''${@:-}\"" >$out/bin/dbus-launch
      chmod +x $out/bin/dbus-launch
    '';
  };

  xpra-run = buildFHSUserEnv rec {
    name = "xpra-run";
    targetPkgs = pkgs: (with pkgs.xorg; [
      xorgserver
      xauth
      libX11
      xorgproto
      libXrender
      libXi
      libXtst
      libXfixes
      libXcomposite
      libXdamage
      libXrandr
      libxkbfile
    ]) ++ (with pkgs; [
      cython
      python3

      pango
      cairo
      gdk-pixbuf
      atk.out
      gtk3
      glib

      ffmpeg_4
      libvpx
      x264
      libwebp
      x265

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav

      pam
      gobject-introspection
    ]) ++ (with python3.pkgs; [
      pillow
      rencode
      pycrypto
      cryptography
      pycups
      lz4
      dbus-python
      netifaces
      numpy
      pygobject3
      pycairo
      gst-python
      pam
      pyopengl
      paramiko
      opencv4
      python-uinput
      pyxdg
      ipaddress
      idna
    ]);

    runScript = writeScript "xpra" ''
      #!${stdenv.shell}

      export PATH=${xpra}/bin:${dbus-launch}/bin:''${PATH:+':'}$PATH
      export PYTHONPATH=${xpra}/lib/python3.7/site-packages/:/usr/lib/python3.7/site-packages''${PYTHONPATH:+':'}$PYTHONPATH

      cmd=$1; shift

      exec $cmd "$@"
    '';
  };
in
stdenv.mkDerivation rec {
  name = "xpra-wrapper";

  phases = [ "installPhase" "fixupPhase" ];

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = (with xorg; [
    libX11
    xorgproto
    libXrender
    libXi
    libXtst
    libXfixes
    libXcomposite
    libXdamage
    libXrandr
    libxkbfile
  ]) ++ [
    cython

    pango
    cairo
    gdk-pixbuf
    atk.out
    gtk3
    glib

    ffmpeg_4
    libvpx
    x264
    libwebp
    x265

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    pam
    gobject-introspection
  ] ++ (with python3.pkgs; [
    pillow
    rencode
    pycrypto
    cryptography
    pycups
    lz4
    dbus-python
    netifaces
    numpy
    pygobject3
    pycairo
    gst-python
    pam
    pyopengl
    paramiko
    opencv4
    python-uinput
    pyxdg
    ipaddress
    idna
  ]);

  installPhase = ''
    mkdir -p $out/bin

    cd ${xpra}/bin
    for cmd in ''$(\ls .); do
      echo -e "#!${stdenv.shell}\nexec ${xpra-run}/bin/xpra-run ''${cmd} \"\$@\"" >$out/bin/''${cmd}
      chmod +x $out/bin/''${cmd}
    done
  '';
}
