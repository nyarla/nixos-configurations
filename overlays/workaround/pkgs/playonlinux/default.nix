{ stdenv, lib, makeWrapper, fetchurl, cabextract, gettext, glxinfo, gnupg
, icoutils, imagemagick, netcat-gnu, p7zip, python2Packages, unzip, wget
, xdg-user-dirs, xterm, pkgs, pkgsi686Linux, which, curl, jq, xorg, libGL }:
let
  version = "4.3.4";

  binpath = lib.makeBinPath [
    cabextract
    python2Packages.python
    gettext
    glxinfo
    gnupg
    icoutils
    imagemagick
    netcat-gnu
    p7zip
    unzip
    wget
    xdg-user-dirs
    xterm
    which
    curl
    jq
  ];

  ld32 = if stdenv.hostPlatform.system == "x86_64-linux" then
    "${pkgsi686Linux.gcc}/nix-support/dynamic-linker"
  else if stdenv.hostPlatform.system == "i686-linux" then
    "${pkgs.gcc}/nix-support/dynamic-linker"
  else
    throw "Unsupported platform for PlayOnLinux: ${stdenv.hostPlatform.system}";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";
  libs = pkgs: lib.makeLibraryPath [ xorg.libX11 libGL ];

  wine-rt-x86 = pkgs.pkgsi686Linux.buildFHSUserEnv rec {
    name = "wine-rt-x86-env";
    targetPkgs = pkgs:
      (with pkgs;
        [
          libcap
          libpng
          libjpeg
          cups
          lcms2
          gettext
          dbus
          mpg123
          openal
          cairo
          libtiff
          unixODBC
          samba4
          ncurses5
          libva
          libpcap
          libv4l
          sane-backends
          gsm
          libgphoto2
          openldap
          fontconfig
          alsaLib
          libpulseaudio
          udev
          vulkan-loader
          SDL2
          gtk3
          glib
          opencl-headers
          ocl-icd
          libxml2
          libxslt
          openssl
          gnutls
          libGLU_combined
          mesa_noglu.osmesa
          libdrm
          perl
          glibcLocales
          fontconfig
          freetype
          jack1
          gcc
          gnumake
          binutils
          glibc
        ] ++ (with gst_all_1; [
          gstreamer
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]) ++ (with xorg; [
          libXi
          libXcursor
          libXrandr
          libXrender
          libXxf86vm
          libXcomposite
          libXext
          libX11
        ]));
    runScript = "env";
  };

  wine-rt-amd64 = pkgs.buildFHSUserEnv rec {
    name = "wine-rt-amd64-env";
    targetPkgs = pkgs:
      (with pkgs;
        [
          libcap
          libpng
          libjpeg
          cups
          lcms2
          gettext
          dbus
          mpg123
          openal
          cairo
          libtiff
          unixODBC
          samba4
          ncurses5
          libva
          libpcap
          libv4l
          sane-backends
          gsm
          libgphoto2
          openldap
          fontconfig
          alsaLib
          libpulseaudio
          udev
          vulkan-loader
          SDL2
          gtk3
          glib
          opencl-headers
          ocl-icd
          libxml2
          libxslt
          openssl
          gnutls
          libGLU_combined
          mesa_noglu.osmesa
          libdrm
          perl
          glibcLocales
          fontconfig
          freetype

          jack1
          gcc
          gnumake
          binutils
          glibc
        ] ++ (with gst_all_1; [
          gstreamer
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]) ++ (with xorg; [
          libXi
          libXcursor
          libXrandr
          libXrender
          libXxf86vm
          libXcomposite
          libXext
          libX11
        ]));
    runScript = "env";
  };

in stdenv.mkDerivation {
  name = "playonlinux-${version}";

  src = fetchurl {
    url =
      "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "019dvb55zqrhlbx73p6913807ql866rm0j011ix5mkk2g79dzhqp";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    python2Packages.python
    python2Packages.wxPython
    python2Packages.setuptools
    xorg.libX11
    libGL
  ];

  patchPhase = ''
    patchShebangs python tests/python
    sed -i "s/ %F//g" etc/PlayOnLinux.desktop

    sed -i 's|{0 }|{0}|' lang/po/ja.po
    ${gettext}/bin/msgfmt lang/po/ja.po -o lang/locale/ja/LC_MESSAGES/pol.mo

    sed -i 's|wine "$@"|$(which wine) "$@"|g' lib/wine.lib
  '';

  installPhase = ''
    install -d $out/share/playonlinux
    cp -r . $out/share/playonlinux/

    install -D -m644 etc/PlayOnLinux.desktop $out/share/applications/playonlinux.desktop
    cp $out/share/applications/playonlinux{,-32bit}.desktop
    cp $out/share/applications/playonlinux{,-64bit}.desktop
    rm $out/share/applications/playonlinux.desktop

    sed -i "s|PlayOnLinux|PlayOnLinux (32bit)|" $out/share/applications/playonlinux-32bit.desktop
    sed -i "s|playonlinux|playonlinux-32bit|"   $out/share/applications/playonlinux-32bit.desktop

    sed -i "s|PlayOnLinux|PlayOnLinux (64bit)|" $out/share/applications/playonlinux-64bit.desktop
    sed -i "s|playonlinux|playonlinux-64bit|"   $out/share/applications/playonlinux-64bit.desktop

    makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux-32bit \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
      --prefix BEFORE_WINE : "${wine-rt-x86}/bin/wine-rt-x86-env" \
      --prefix PATH : ${binpath}

    makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux-64bit \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
      --prefix BEFORE_WINE : "${wine-rt-amd64}/bin/wine-rt-amd64-env" \
      --prefix PATH : ${binpath}

    bunzip2 $out/share/playonlinux/bin/check_dd_x86.bz2
    patchelf --set-interpreter $(cat ${ld32}) --set-rpath ${
      libs pkgsi686Linux
    } $out/share/playonlinux/bin/check_dd_x86
    ${if stdenv.hostPlatform.system == "x86_64-linux" then ''
      bunzip2 $out/share/playonlinux/bin/check_dd_amd64.bz2
      patchelf --set-interpreter $(cat ${ld64}) --set-rpath ${
        libs pkgs
      } $out/share/playonlinux/bin/check_dd_amd64
    '' else ''
      rm $out/share/playonlinux/bin/check_dd_amd64.bz2
    ''}
    for f in $out/share/playonlinux/bin/*; do
      bzip2 $f
    done
  '';

  meta = with lib; {
    description = "GUI for managing Windows programs under linux";
    homepage = "https://www.playonlinux.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.a1russell ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
