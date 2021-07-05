self: super:
let require = path: args: super.callPackage (import path) args;
in {
  airwave = require ./pkgs/airwave/default.nix { };

  aseprite = super.aseprite.override { unfree = true; };

  carla = require ./pkgs/carla/default.nix { };

  fbterm = super.fbterm.overrideAttrs
    (old: rec { patches = [ ./pkgs/fbterm/color.patch ]; });

  ibus-skk = require ./pkgs/ibus-skk/default.nix { };

  jwm = require ./pkgs/jwm/default.nix { };

  playonlinux = let
    python = super.python2.withPackages (ps: with ps; [ wxPython setuptools ]);
    binPath = super.lib.makeBinPath (([ python ]) ++ (with super; [
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
    mkWineRuntime = stdenv: p:
      p.buildFHSUserEnv rec {
        name = "wine-runtime-" + (if stdenv.isx86_64 then "x64" else "x86");
        targetPkgs = ps:
          with ps;
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
    wine-runtime-x86 =
      mkWineRuntime super.pkgs.pkgsi686Linux.stdenv super.pkgs.pkgsi686Linux;
  in super.playonlinux.overrideAttrs (old: rec {

    src = super.fetchurl {
      url =
        "https://github.com/PlayOnLinux/POL-POM-4/archive/b06a572b4d9db0eddf25b1e06e630bf19f24de51.tar.gz";
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
}
