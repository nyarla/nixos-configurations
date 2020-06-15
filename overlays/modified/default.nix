self: super:
let
  require = path: args: super.callPackage (import path) args;
in
{
  airwave = require ./pkgs/airwave/default.nix { };

  aseprite = super.aseprite.override {
    unfree = true;
  };

  carla = require ./pkgs/carla/default.nix { };

  fbterm = super.fbterm.overrideAttrs (old: rec {
    patches = [
      ./pkgs/fbterm/color.patch
    ];
  });

  ibus-skk = require ./pkgs/ibus-skk/default.nix { };

  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ self.uim super.dbus ];
    configureFlags = old.configureFlags ++ [
      "--enable-uim"
    ];
  });

  playonlinux =
    let
      python = super.python2.withPackages (ps: with ps; [
        wxPython
        setuptools
      ]);
      binPath = super.stdenv.lib.makeBinPath (([ python ]) ++ (with super; [
        cabextract
        gettext
        glxinfo
        gnupg
        icoutils
        imagemagick
        netcat-gnu
        p7zip
        unzip
        wget
        wine
        xdg-user-dirs
        xterm
        which
        curl
        jq
      ]));
      mkWineRuntime = stdenv: p: p.buildFHSUserEnv rec {
        name = "wine-runtime-" + (if stdenv.isx86_64 then "x64" else "x86");
        targetPkgs = ps: with ps; [
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
          libGLU
          mesa_noglu.osmesa
          libdrm
          perl
          glibcLocales
          fontconfig
          freetype
          jack2Full
          gcc
          gnumake
          binutils
          glibc
          vulkan-loader
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
          libxcb
        ]);

        runScript = "env";
      };
      wine-runtime-x64 = mkWineRuntime super.stdenv super.pkgs;
      wine-runtime-x86 = mkWineRuntime super.pkgs.pkgsi686Linux.stdenv super.pkgs.pkgsi686Linux;
    in
    super.playonlinux.overrideAttrs (old: rec {

      src = super.fetchurl {
        url = "https://github.com/PlayOnLinux/POL-POM-4/archive/b06a572b4d9db0eddf25b1e06e630bf19f24de51.tar.gz";
        sha256 = "1iz4g08hcxhn29b9kq501vs13lnk6prl7f6k165fy0k31k1m955s";
      };

      postPatch = ''
        patchShebangs python tests/python
        sed -i "s/ %F//g" etc/PlayOnLinux.desktop

        sed -i 's|{0 }|{0}|' lang/po/ja.po
        ${super.gettext}/bin/msgfmt lang/po/ja.po -o lang/locale/ja/LC_MESSAGES/pol.mo

        sed -i 's|self.available_packages.split("\n")|self.available_packages|' python/configurewindow/PackageList.py

        sed -i 's|wine "$@"|$(which wine) $@|g' lib/wine.lib
      '';

      installPhase = old.installPhase + ''
        rm $out/bin/playonlinux
        makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux \
          --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
          --prefix BEFORE_WINE : ${wine-runtime-x64}/bin/${wine-runtime-x64.name} \
          --prefix PATH : ${binPath}

        makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux-32bit-only \
          --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
          --prefix BEFORE_WINE : ${wine-runtime-x86}/bin/${wine-runtime-x86.name} \
          --prefix PATH : ${binPath}

        ln -sf ${wine-runtime-x86}/bin/${wine-runtime-x86.name} $out/bin/winepol-32bit-loader
        ln -sf ${wine-runtime-x64}/bin/${wine-runtime-x64.name} $out/bin/winepol-64bit-loader

        chmod +x $out/bin/playonlinux-32bit-only
      '';
    });

  run-scaled = super.run-scaled.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's!attach "$DISPLAYNUM"!attach socket:///run/user/$(id -u)/xpra/$(hostname)-''${DISPLAYNUM#:}!' run_scaled
    '';
  });

  tmux = super.tmux.overrideAttrs (old: rec {
    patches = [
      (super.fetchurl {
        url = "https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-2.9a-fix.diff";
        sha256 = "11siyirp9wlyqq9ga4iwxw6cb4zg5n58jklgab2dkp469wxbx2ql";
      })
    ];
  });

  uim = (super.uim.override { withQt = false; }).overrideAttrs (old: rec {
    dontUseQmakeConfigure = true;

    prePatch = ''
      sed -i "s|@DESTDIR@\$\$\[QT_INSTALL_PLUGINS\]|$out/lib/qt-${super.qt5.qtbase.version}/plugins|" qt5/immodule/quimplatforminputcontextplugin.pro.in
    '' + old.prePatch;

    nativeBuildInputs = old.nativeBuildInputs ++ [
      super.qt5.qmake
    ];

    buildInputs = old.buildInputs ++ [
      super.qt5.qtbase.bin
      super.qt5.qtbase.dev
      super.qt5.qtx11extras
      super.qt5.qttools
    ];

    configureFlags = old.configureFlags ++ [
      "--with-qt5-immodule"
      "--with-qt5"
    ];
  });

  virtualbox = super.virtualbox.overrideAttrs (old: rec {
    version = "6.1.10";
    src = super.fetchurl {
      url = "https://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
      sha256 = "37d8b30c0be82a50c858f3fc70cde967882239b6212bb32e138d3615b423c477";
    };
  });

  virtualboxExtpack =
    let
      version = "6.1.10";
    in
    super.fetchurl rec {
      name = "Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack";
      url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
      sha256 = "03067f27f4da07c5d0fdafc56d27e3ea23a60682b333b2a1010fb74ef9a40c28";
    };
  vlang = super.vlang.overrideAttrs (old: rec {
    version = "0.2-dev";
    src = super.fetchFromGitHub {
      owner = "vlang";
      repo = "v";
      rev = "722a2c71c3549fa64a1625ebd940c3633d61814e";
      sha256 = "0k4gmyc2pxrkwf7lh0dqrpbziagrzxzg2ww7kd3l659gp1jfwjbs";
    };

    vc = super.fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "45f667a15bcb6f07949f3af62efa30929e82be59";
      sha256 = "0swaw9s79djrgqxq98bdh1w5azkykp2d3vv80918ilwkn47n0pvi";
    };

    buildPhase = ''
      runHook preBuild
      cc -std=gnu11 $CFLAGS -w -o v $vc/v.c -lm $LDFLAGS
      ./v self
      runHook postBuild
    '';
  });

  # xpra = require ./pkgs/xpra/default.nix { };
}
