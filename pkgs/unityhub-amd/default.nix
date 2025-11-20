{
  unityhub,
  buildFHSEnv,
  amd-run,
}:
unityhub.overrideAttrs (old: rec {
  fhsEnv = buildFHSEnv {
    pname = "${old.pname}-fhs-env";
    inherit (old) version;
    runScript = "";

    targetPkgs =
      p: with p; [
        # Unity Hub binary dependencies
        xorg.libXrandr
        xdg-utils

        # GTK filepicker
        gsettings-desktop-schemas
        hicolor-icon-theme

        # Bug Reporter dependencies
        fontconfig
        freetype
        lsb-release
      ];

    multiPkgs =
      p: with p; [
        # Unity Hub ldd dependencies
        cups
        gtk3
        expat
        libxkbcommon
        lttng-ust_2_12
        krb5
        alsa-lib
        nss
        libdrm
        libgbm
        nspr
        atk
        dbus
        at-spi2-core
        pango
        xorg.libXcomposite
        xorg.libXext
        xorg.libXdamage
        xorg.libXfixes
        xorg.libxcb
        xorg.libxshmfence
        xorg.libXScrnSaver
        xorg.libXtst

        # Unity Hub additional dependencies
        libva
        openssl
        cairo
        libnotify
        libuuid
        libsecret
        udev
        libappindicator
        wayland
        cpio
        icu
        libpulseaudio

        # Unity Editor dependencies
        libglvnd # provides ligbl
        xorg.libX11
        xorg.libXcursor
        glib
        gdk-pixbuf
        libxml2_13
        zlib
        clang
        git # for git-based packages in unity package manager

        # Unity Editor 6000 specific dependencies
        harfbuzz
        vulkan-loader

        # Unity Bug Reporter specific dependencies
        xorg.libICE
        xorg.libSM

        # fonts
        noto-fonts
        noto-fonts-jp
        noto-fonts-color-emoji
        hackgen-font
        nerd-fonts.hack
        dejavu_fonts
      ];
  };

  installPhase =
    builtins.replaceStrings
      [ (toString old.fhsEnv) "--add-flags" ]
      [
        (toString fhsEnv)
        "--add-flag ${amd-run}/bin/amd-run --add-flags"
      ]
      old.installPhase;

  passthru.unity-run = fhsEnv;
})
